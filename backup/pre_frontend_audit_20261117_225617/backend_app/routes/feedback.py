"""Student feedback routes.

Course feedback workflow:
  1. Student lists their enrolled courses (with assigned faculty).
  2. Student picks a course; faculty assigned to that subject are returned.
  3. Student submits rating + comments; server re-validates enrolment,
     faculty assignment, and duplicate submissions before persisting.
"""

from __future__ import annotations

from flask import Blueprint, abort, jsonify, request, session

from app.auth.security import login_required
from app.db import get_cursor
from app.services import feedback_service

bp = Blueprint("feedback", __name__, url_prefix="/feedback")


@bp.get("/courses")
@login_required
def courses():
    """Return the signed-in student's enrolled courses with assigned faculty."""
    role = session.get("role")
    if not feedback_service.can_submit_feedback(role):
        abort(403)

    student_id = session.get("student_id")
    if not student_id:
        abort(403)

    courses = feedback_service.list_courses_for_student(role, student_id)
    return jsonify({"courses": courses})


@bp.get("/faculty")
@login_required
def faculty():
    """Return faculty assigned to a subject for a semester."""
    subject_id = request.args.get("subject_id", type=int)
    semester_id = request.args.get("semester_id", type=int)
    if not subject_id or not semester_id:
        return jsonify({"faculty": []}), 400

    with get_cursor() as cursor:
        faculty = feedback_service.list_faculty_for_subject(cursor, subject_id, semester_id)

    return jsonify({"faculty": faculty})


@bp.post("")
@login_required
def submit():
    """Submit course feedback for the signed-in student."""
    role = session.get("role")
    if not feedback_service.can_submit_feedback(role):
        abort(403)

    student_id = session.get("student_id")
    payload = request.get_json(silent=True) or {}
    subject_id = payload.get("subject_id")
    faculty_id = payload.get("faculty_id")
    semester_id = payload.get("semester_id")
    rating = payload.get("rating")
    comments = payload.get("comments")
    is_anonymous = bool(payload.get("is_anonymous"))

    ok, error = feedback_service.submit_feedback(
        role,
        student_id=student_id,
        subject_id=subject_id,
        faculty_id=faculty_id,
        semester_id=semester_id,
        rating=rating,
        comments=comments,
        is_anonymous=is_anonymous,
    )
    if not ok:
        return jsonify({"status": "error", "message": error}), 400

    return jsonify({"status": "submitted"}), 201
