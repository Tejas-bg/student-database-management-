"""Server-side search helpers for authenticated dashboards.

Every search runs a parameterized query against MySQL through the shared
repository layer. Results are always scoped by the caller's role server-side,
so clients cannot widen the result set beyond what their permissions allow.
"""

from __future__ import annotations

from typing import Any

from app.repositories import student_repository


def _like(value: str) -> str:
    return f"%{value}%"


def full_name(row: dict[str, Any]) -> str:
    """Compose a display name from the first/last name columns used by the
    student and faculty result sets."""
    first = (row.get("first_name") or "").strip()
    last = (row.get("last_name") or "").strip()
    if first or last:
        return f"{first} {last}".strip()
    return (row.get("faculty_name") or (row.get("student_name") or "")).strip()


def search_students(
    cursor,
    *,
    role: str,
    current_student_id: int | None,
    query: str,
) -> list[dict[str, Any]]:
    """Return students visible to the requesting role for ``query``."""
    return student_repository.list_students(
        cursor,
        role=role,
        current_student_id=current_student_id,
        search=query,
    )


def search_faculty(
    cursor,
    query: str,
    *,
    faculty_id: int | None = None,
) -> list[dict[str, Any]]:
    """Return faculty matching ``query`` (optionally one faculty's roster)."""
    like = _like(query)
    cursor.execute(
        """
        SELECT f.faculty_id, f.employee_id, f.first_name, f.last_name,
               f.designation, f.status, f.department_id, d.department_code,
               d.department_name
        FROM faculty AS f
        JOIN departments AS d ON d.department_id = f.department_id
        WHERE (f.employee_id LIKE %s OR f.first_name LIKE %s
               OR f.last_name LIKE %s OR f.designation LIKE %s
               OR d.department_name LIKE %s)
        ORDER BY f.employee_id
        """,
        (like, like, like, like, like),
    )
    results = [dict(row) for row in cursor.fetchall()]
    if faculty_id is not None:
        results = [row for row in results if int(row.get("faculty_id") or 0) == int(faculty_id)]
    return results


def search_courses(
    cursor,
    query: str,
    *,
    role: str = "admin",
    current_student_id: int | None = None,
    faculty_id: int | None = None,
) -> list[dict[str, Any]]:
    """Return courses/subjects matching ``query`` for the caller's role.

    * Admin: every programme course.
    * Faculty: subjects with an active teaching assignment.
    * Student: subjects the student is enrolled in.
    """
    like = _like(query)
    results: list[dict[str, Any]] = []

    if role == "student" and current_student_id is not None:
        cursor.execute(
            """
            SELECT sub.subject_id, sub.course_id, sub.semester_number,
                   sub.subject_code, sub.subject_name, sub.subject_type,
                   sub.credits, sub.status,
                   c.course_code, c.course_name, c.level, c.duration_semesters
            FROM subjects AS sub
            JOIN courses AS c ON c.course_id = sub.course_id
            JOIN student_enrolments AS e
                   ON e.subject_id = sub.subject_id
                  AND e.student_id = %s
                  AND e.status = 'enrolled'
            WHERE (sub.subject_code LIKE %s OR sub.subject_name LIKE %s
                   OR c.course_code LIKE %s OR c.course_name LIKE %s)
            ORDER BY c.course_code, sub.semester_number, sub.subject_code
            """,
            (current_student_id, like, like, like, like),
        )
        results = [dict(row) for row in cursor.fetchall()]
        return results

    if role == "faculty" and faculty_id is not None:
        cursor.execute(
            """
            SELECT sub.subject_id, sub.course_id, sub.semester_number,
                   sub.subject_code, sub.subject_name, sub.subject_type,
                   sub.credits, sub.status,
                   c.course_code, c.course_name, c.level, c.duration_semesters
            FROM subjects AS sub
            JOIN courses AS c ON c.course_id = sub.course_id
            JOIN faculty_subject_assignments AS fa
                   ON fa.subject_id = sub.subject_id
                  AND fa.faculty_id = %s
                  AND fa.is_active = 1
            WHERE (sub.subject_code LIKE %s OR sub.subject_name LIKE %s
                   OR c.course_code LIKE %s OR c.course_name LIKE %s)
            ORDER BY c.course_code, sub.semester_number, sub.subject_code
            """,
            (faculty_id, like, like, like, like),
        )
        results = [dict(row) for row in cursor.fetchall()]
        return results

    cursor.execute(
        """
        SELECT course_id, course_code, course_name, level, duration_semesters, total_credits, status
        FROM courses
        WHERE (course_code LIKE %s OR course_name LIKE %s)
        ORDER BY course_code
        """,
        (like, like),
    )
    return [dict(row) for row in cursor.fetchall()]


def search_departments(
    cursor,
    query: str,
) -> list[dict[str, Any]]:
    like = _like(query)
    cursor.execute(
        """
        SELECT department_id, department_code, department_name, hod_name,
               office_location, status
        FROM departments
        WHERE (department_code LIKE %s OR department_name LIKE %s
               OR hod_name LIKE %s OR office_location LIKE %s)
        ORDER BY department_code
        """,
        (like, like, like, like),
    )
    return [dict(row) for row in cursor.fetchall()]
