"""Business logic for student CRUD operations with permission enforcement."""

from __future__ import annotations

from app.db import get_cursor
from app.repositories import student_repository

# Roles allowed to manage (add/update/delete) student records
MANAGE_ROLES = {"admin"}

# Roles allowed to view/search student records
VIEW_ROLES = {"admin", "faculty", "student"}

# Sentinel hash for new student accounts (no real password set yet)
SENTINEL_PASSWORD_HASH = "!NO_LOGIN_HASH_SET"


def can_manage(role: str) -> bool:
    """Return True if the role can add/update/delete students."""
    return role in MANAGE_ROLES


def can_view(role: str) -> bool:
    """Return True if the role can view/search student records."""
    return role in VIEW_ROLES


def is_own_record(role: str, current_student_id: int | None, student_id: int) -> bool:
    """Return True if the student is viewing their own record."""
    return role == "student" and current_student_id is not None and current_student_id == student_id


def list_students(
    role: str,
    *,
    current_student_id: int | None = None,
    search: str | None = None,
) -> list[dict]:
    """Return students visible to the requesting role."""
    if not can_view(role):
        return []
    with get_cursor() as cursor:
        return student_repository.list_students(
            cursor,
            role=role,
            current_student_id=current_student_id,
            search=search,
        )


def get_student(
    role: str,
    student_id: int,
    *,
    current_student_id: int | None = None,
) -> dict | None:
    """Return a single student if the role is allowed to view it."""
    if not can_view(role):
        return None
    if role == "student" and not is_own_record(role, current_student_id, student_id):
        return None
    with get_cursor() as cursor:
        return student_repository.get_student(cursor, student_id)


def create_student(
    role: str,
    *,
    department_id: int,
    course_id: int,
    usn: str,
    first_name: str,
    last_name: str,
    date_of_birth: str | None,
    gender: str | None,
    email: str | None,
    phone: str | None,
    address_line1: str | None,
    city: str | None,
    state: str | None,
    pincode: str | None,
    admission_year: int,
    current_semester: int,
    status: str = "active",
) -> int | None:
    """Create a student record. Only admins may create students.

    Creates both the ``users`` account (with the USN as login identifier and a
    sentinel password hash) and the ``students`` profile in one transaction.
    Returns the new ``student_id`` or ``None`` if not authorized.
    """
    if not can_manage(role):
        return None
    with get_cursor(commit=True) as cursor:
        # 1. Create the user account
        cursor.execute(
            """
            INSERT INTO users
                (role_id, login_identifier, email, password_hash,
                 account_status, is_active, must_change_password)
            VALUES (%s, %s, %s, %s, 'pending_reset', 1, 1)
            """,
            (
                1,  # role_id = student
                usn,
                email,
                SENTINEL_PASSWORD_HASH,
            ),
        )
        user_id = int(cursor.lastrowid)

        # 2. Create the student profile linked to the user
        student_id = student_repository.create_student(
            cursor,
            user_id=user_id,
            department_id=department_id,
            course_id=course_id,
            usn=usn,
            first_name=first_name,
            last_name=last_name,
            date_of_birth=date_of_birth,
            gender=gender,
            email=email,
            phone=phone,
            address_line1=address_line1,
            city=city,
            state=state,
            pincode=pincode,
            admission_year=admission_year,
            current_semester=current_semester,
            status=status,
        )
    return student_id


def update_student(
    role: str,
    student_id: int,
    *,
    current_student_id: int | None = None,
    department_id: int,
    course_id: int,
    usn: str,
    first_name: str,
    last_name: str,
    date_of_birth: str | None,
    gender: str | None,
    email: str | None,
    phone: str | None,
    address_line1: str | None,
    city: str | None,
    state: str | None,
    pincode: str | None,
    admission_year: int,
    current_semester: int,
    status: str,
) -> bool:
    """Update a student record. Only admins may update."""
    if not can_manage(role):
        return False
    with get_cursor(commit=True) as cursor:
        # Update the student profile
        student_repository.update_student(
            cursor,
            student_id,
            department_id=department_id,
            course_id=course_id,
            usn=usn,
            first_name=first_name,
            last_name=last_name,
            date_of_birth=date_of_birth,
            gender=gender,
            email=email,
            phone=phone,
            address_line1=address_line1,
            city=city,
            state=state,
            pincode=pincode,
            admission_year=admission_year,
            current_semester=current_semester,
            status=status,
        )
        # Keep the user login_identifier in sync with the USN
        cursor.execute(
            "SELECT user_id FROM students WHERE student_id = %s",
            (student_id,),
        )
        row = cursor.fetchone()
        if row:
            cursor.execute(
                "UPDATE users SET login_identifier = %s, email = %s WHERE user_id = %s",
                (usn, email, int(row["user_id"])),
            )
    return True


def delete_student(role: str, student_id: int) -> bool:
    """Delete a student record and its linked user account. Only admins may delete."""
    if not can_manage(role):
        return False
    with get_cursor(commit=True) as cursor:
        # Get the linked user_id before deleting the student
        cursor.execute("SELECT user_id FROM students WHERE student_id = %s", (student_id,))
        row = cursor.fetchone()
        user_id = int(row["user_id"]) if row else None

        student_repository.delete_student(cursor, student_id)

        if user_id is not None:
            cursor.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
    return True


def list_departments() -> list[dict]:
    """Return active departments for dropdowns."""
    with get_cursor() as cursor:
        return student_repository.list_departments(cursor)


def list_courses() -> list[dict]:
    """Return active courses for dropdowns."""
    with get_cursor() as cursor:
        return student_repository.list_courses(cursor)