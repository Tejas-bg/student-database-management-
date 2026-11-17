"""Authenticated role landing pages backed by real MySQL queries."""

from __future__ import annotations

from datetime import datetime

from flask import Blueprint, abort, jsonify, render_template, request, session

from app.auth.security import login_required
from app.db import get_cursor
from app.repositories import dashboard_repository
from app.services import search_service

bp = Blueprint("dashboard", __name__)


def _greeting(name: str | None) -> str:
    hour = datetime.now().hour
    period = "morning" if hour < 12 else "afternoon" if hour < 17 else "evening"
    label = name or "there"
    return f"Good {period}, {label}."


@bp.get("/dashboard/search")
@login_required
def search():
    """Return a role-aware, server-side search result set for dashboards."""
    q = (request.args.get("q") or "").strip()
    kind = (request.args.get("type") or "students").strip().lower()
    role = session.get("role") or "student"

    results: list[dict] = []
    with get_cursor() as cursor:
        if kind == "students":
            results = search_service.search_students(
                cursor,
                role=role,
                current_student_id=session.get("student_id"),
                query=q,
            )
        elif kind == "faculty":
            if q:
                results = search_service.search_faculty(cursor, q)
        elif kind == "courses":
            if q:
                results = search_service.search_courses(
                    cursor,
                    q,
                    role=role,
                    current_student_id=session.get("student_id"),
                    faculty_id=session.get("faculty_id"),
                )
        elif kind == "departments":
            if q:
                results = search_service.search_departments(cursor, q)

    return jsonify({"type": kind, "query": q, "results": results}), 200


@bp.get("/")
@bp.get("/dashboard")
@login_required
def index():
    role = session.get("role")
    display_name = session.get("display_name") or session.get("login_identifier") or "there"
    context: dict = {
        "role": role,
        "role_name": session.get("role_name"),
        "display_name": display_name,
        "login_identifier": session.get("login_identifier"),
        "greeting": _greeting(display_name),
    }

    with get_cursor() as cursor:
        if role == "student":
            student_id = session.get("student_id")
            if not student_id:
                abort(403)
            context["profile"] = dashboard_repository.student_profile(cursor, student_id)
            context["summary"] = dashboard_repository.student_overview(cursor, student_id)
        elif role == "faculty":
            faculty_id = session.get("faculty_id")
            if not faculty_id:
                abort(403)
            context["profile"] = dashboard_repository.faculty_profile(cursor, faculty_id)
            context["assignments"] = dashboard_repository.faculty_assignments(cursor, faculty_id)
        elif role == "admin":
            context["summary"] = dashboard_repository.admin_summary(cursor)
        else:
            abort(403)

    return render_template("dashboard.html", **context)
