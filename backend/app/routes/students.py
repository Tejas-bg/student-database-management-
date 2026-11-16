"""Student management CRUD routes.

Access rules:
* Admin: add, view, search, update, delete all student records.
* Faculty: view and search all student records.
* Student: view only their own record.
"""

from __future__ import annotations

import mysql.connector.errors

from flask import (
    Blueprint,
    abort,
    flash,
    redirect,
    render_template,
    request,
    session,
    url_for,
)

from app.auth.security import login_required
from app.db import get_cursor
from app.repositories import student_repository
from app.services import student_service
from app.validators.student_validator import validate_student_form

bp = Blueprint("students", __name__, url_prefix="/students")


def _current_user_role() -> str | None:
    return session.get("role")


def _current_student_id() -> int | None:
    return session.get("student_id")


@bp.get("/")
@login_required
def index():
    """List/search students (admin/faculty) or redirect to own profile (student)."""
    role = _current_user_role()
    search = request.args.get("search", "").strip() or None

    if role == "student":
        student_id = _current_student_id()
        if not student_id:
            abort(403)
        return redirect(url_for("students.detail", student_id=student_id))

    students = student_service.list_students(
        role,
        current_student_id=_current_student_id(),
        search=search,
    )
    return render_template(
        "students/list.html",
        students=students,
        search=search or "",
        role=role,
    )


@bp.get("/add")
@login_required
def add_form():
    """Show the add-student form (admin only)."""
    role = _current_user_role()
    if not student_service.can_manage(role):
        abort(403)
    departments = student_service.list_departments()
    courses = student_service.list_courses()
    return render_template(
        "students/add.html",
        departments=departments,
        courses=courses,
        role=role,
    )


@bp.post("/add")
@login_required
def add():
    """Create a new student record (admin only)."""
    role = _current_user_role()
    if not student_service.can_manage(role):
        abort(403)

    cleaned, errors = validate_student_form(request.form)
    if errors:
        departments = student_service.list_departments()
        courses = student_service.list_courses()
        return (
            render_template(
                "students/add.html",
                departments=departments,
                courses=courses,
                errors=errors,
                form=request.form,
                role=role,
            ),
            400,
        )

    # Check for duplicate USN in students table
    with get_cursor() as cursor:
        existing = student_repository.get_student_by_usn(cursor, cleaned["usn"])
    if existing:
        errors.append("A student with this USN already exists.")
        departments = student_service.list_departments()
        courses = student_service.list_courses()
        return (
            render_template(
                "students/add.html",
                departments=departments,
                courses=courses,
                errors=errors,
                form=request.form,
                role=role,
            ),
            400,
        )

    try:
        new_id = student_service.create_student(
            role,
            department_id=cleaned["department_id"],
            course_id=cleaned["course_id"],
            usn=cleaned["usn"],
            first_name=cleaned["first_name"],
            last_name=cleaned["last_name"],
            date_of_birth=cleaned["date_of_birth"],
            gender=cleaned["gender"],
            email=cleaned["email"],
            phone=cleaned["phone"],
            address_line1=cleaned["address_line1"],
            city=cleaned["city"],
            state=cleaned["state"],
            pincode=cleaned["pincode"],
            admission_year=cleaned["admission_year"],
            current_semester=cleaned["current_semester"],
            status=cleaned["status"],
        )
    except mysql.connector.errors.IntegrityError:
        errors.append("A student with this USN or email already exists.")
        departments = student_service.list_departments()
        courses = student_service.list_courses()
        return (
            render_template(
                "students/add.html",
                departments=departments,
                courses=courses,
                errors=errors,
                form=request.form,
                role=role,
            ),
            400,
        )
    if new_id is None:
        abort(403)

    flash("Student record created successfully.", "success")
    return redirect(url_for("students.detail", student_id=new_id))


@bp.get("/<int:student_id>")
@login_required
def detail(student_id: int):
    """View a single student record."""
    role = _current_user_role()
    # Check existence first (regardless of authorization)
    with get_cursor() as cursor:
        exists = student_repository.get_student(cursor, student_id) is not None
    if not exists:
        abort(404)
    student = student_service.get_student(
        role,
        student_id,
        current_student_id=_current_student_id(),
    )
    if student is None:
        abort(403)
    return render_template("students/detail.html", student=student, role=role)


@bp.get("/<int:student_id>/edit")
@login_required
def edit_form(student_id: int):
    """Show the edit-student form (admin only)."""
    role = _current_user_role()
    if not student_service.can_manage(role):
        abort(403)
    student = student_service.get_student(role, student_id)
    if student is None:
        abort(404)
    departments = student_service.list_departments()
    courses = student_service.list_courses()
    return render_template(
        "students/edit.html",
        student=student,
        departments=departments,
        courses=courses,
        role=role,
    )


@bp.post("/<int:student_id>/edit")
@login_required
def edit(student_id: int):
    """Update a student record (admin only)."""
    role = _current_user_role()
    if not student_service.can_manage(role):
        abort(403)

    cleaned, errors = validate_student_form(request.form)
    if errors:
        student = student_service.get_student(role, student_id)
        if student is None:
            abort(404)
        departments = student_service.list_departments()
        courses = student_service.list_courses()
        return (
            render_template(
                "students/edit.html",
                student=student,
                departments=departments,
                courses=courses,
                errors=errors,
                form=request.form,
                role=role,
            ),
            400,
        )

    try:
        ok = student_service.update_student(
            role,
            student_id,
            current_student_id=_current_student_id(),
            department_id=cleaned["department_id"],
            course_id=cleaned["course_id"],
            usn=cleaned["usn"],
            first_name=cleaned["first_name"],
            last_name=cleaned["last_name"],
            date_of_birth=cleaned["date_of_birth"],
            gender=cleaned["gender"],
            email=cleaned["email"],
            phone=cleaned["phone"],
            address_line1=cleaned["address_line1"],
            city=cleaned["city"],
            state=cleaned["state"],
            pincode=cleaned["pincode"],
            admission_year=cleaned["admission_year"],
            current_semester=cleaned["current_semester"],
            status=cleaned["status"],
        )
    except mysql.connector.errors.IntegrityError:
        errors.append("A student with this USN or email already exists.")
        student = student_service.get_student(role, student_id)
        if student is None:
            abort(404)
        departments = student_service.list_departments()
        courses = student_service.list_courses()
        return (
            render_template(
                "students/edit.html",
                student=student,
                departments=departments,
                courses=courses,
                errors=errors,
                form=request.form,
                role=role,
            ),
            400,
        )
    if not ok:
        abort(403)

    flash("Student record updated successfully.", "success")
    return redirect(url_for("students.detail", student_id=student_id))


@bp.post("/<int:student_id>/delete")
@login_required
def delete(student_id: int):
    """Delete a student record (admin only)."""
    role = _current_user_role()
    if not student_service.can_manage(role):
        abort(403)

    ok = student_service.delete_student(role, student_id)
    if not ok:
        abort(403)

    flash("Student record deleted successfully.", "success")
    return redirect(url_for("students.index"))