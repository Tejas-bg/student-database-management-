"""Business logic for student feedback with permission enforcement."""

from __future__ import annotations

from app.db import get_cursor
from app.repositories import feedback_repository

FEEDBACK_CATEGORY_COURSE = "course"
MAX_RATING = 5
MAX_COMMENTS_LENGTH = 2000


def can_submit_feedback(role: str) -> bool:
    """Only students may submit course feedback."""
    return role == "student"


def list_courses_for_student(role: str, student_id: int | None) -> list[dict]:
    """Return the signed-in student's enrolled courses with assigned faculty."""
    if not can_submit_feedback(role) or not student_id:
        return []
    with get_cursor() as cursor:
        return feedback_repository.list_student_courses(cursor, student_id)


def list_faculty_for_subject(cursor, subject_id: int, semester_id: int) -> list[dict]:
    """Return the faculty assigned to a subject for a semester."""
    return feedback_repository.list_faculty_for_subject(cursor, subject_id, semester_id)


def submit_feedback(
    role: str,
    *,
    student_id: int | None,
    subject_id: int | None,
    faculty_id: int | None,
    semester_id: int | None,
    rating: int | None,
    comments: str | None,
    is_anonymous: bool,
) -> tuple[bool, str]:
    """Validate and persist a course feedback submission.

    Returns ``(ok, error_message)``. Authorization and referential integrity are
    checked before anything is written; failures never persist partial state.
    """
    if not can_submit_feedback(role):
        return False, "Feedback may only be submitted by a student account."
    if not student_id:
        return False, "You must be signed in as a student to submit feedback."

    if not subject_id or not faculty_id or not semester_id:
        return False, "Course, faculty, and semester are required."

    if not isinstance(rating, int) or isinstance(rating, bool) or not (1 <= rating <= MAX_RATING):
        return False, "Please choose a rating between 1 and 5."

    cleaned_comments = (comments or "").strip()
    if len(cleaned_comments) > MAX_COMMENTS_LENGTH:
        return False, "Comments must be under 2000 characters."

    with get_cursor(commit=True) as cursor:
        enrolment = feedback_repository.get_enrolment(cursor, student_id, subject_id)
        if enrolment is None:
            return False, "You are not enrolled in the selected course."

        if int(enrolment.get("semester_id") or 0) != int(semester_id or 0):
            return False, "The selected semester does not match your enrolment."

        faculty_rows = feedback_repository.list_faculty_for_subject(cursor, subject_id, semester_id)
        faculty = next(
            (row for row in faculty_rows if int(row.get("faculty_id") or 0) == int(faculty_id or 0)),
            None,
        )
        if faculty is None:
            return False, "The selected faculty is not assigned to this course."

        existing = feedback_repository.find_feedback(cursor, student_id, subject_id, semester_id)
        if existing is not None:
            return False, "You have already submitted feedback for this course."

        feedback_repository.insert_feedback(
            cursor,
            student_id=student_id,
            subject_id=subject_id,
            faculty_id=faculty_id,
            semester_id=semester_id,
            rating=rating,
            comments=cleaned_comments,
            is_anonymous=bool(is_anonymous),
        )

    return True, ""
