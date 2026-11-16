"""Authenticated role landing pages backed by real MySQL queries."""

from __future__ import annotations

from flask import Blueprint, abort, render_template, session

from app.auth.security import login_required
from app.db import get_cursor
from app.repositories import dashboard_repository

bp = Blueprint("dashboard", __name__)


@bp.get("/")
@bp.get("/dashboard")
@login_required
def index():
    role = session.get("role")
    context: dict = {
        "role": role,
        "role_name": session.get("role_name"),
        "display_name": session.get("display_name"),
        "login_identifier": session.get("login_identifier"),
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
