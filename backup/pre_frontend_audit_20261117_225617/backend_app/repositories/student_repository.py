"""Data access for student records. Every statement is parameterized."""

from __future__ import annotations

from mysql.connector.cursor import MySQLCursor

_LIST_STUDENTS_SQL = """
SELECT
    s.student_id,
    s.usn,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    s.date_of_birth,
    s.gender,
    s.address_line1,
    s.city,
    s.state,
    s.pincode,
    s.admission_year,
    s.current_semester,
    s.status,
    s.created_at,
    s.updated_at,
    d.department_code,
    d.department_name,
    c.course_code,
    c.course_name,
    u.login_identifier,
    u.account_status AS account_status,
    u.is_active AS is_active
FROM students AS s
JOIN departments AS d ON d.department_id = s.department_id
JOIN courses AS c ON c.course_id = s.course_id
JOIN users AS u ON u.user_id = s.user_id
"""


def list_students(
    cursor: MySQLCursor,
    *,
    role: str,
    current_student_id: int | None = None,
    search: str | None = None,
) -> list[dict]:
    """Return students visible to the requesting role.

    * Admin: all students.
    * Faculty: all students.
    * Student: only their own record.
    """
    params: list = []
    sql = _LIST_STUDENTS_SQL

    if role == "student" and current_student_id is not None:
        sql += " WHERE s.student_id = %s"
        params.append(current_student_id)
    elif role not in ("admin", "faculty"):
        return []

    if search:
        like = f"%{search}%"
        if params:
            sql += " AND ("
        else:
            sql += " WHERE ("
        sql += (
            "s.usn LIKE %s OR s.first_name LIKE %s OR s.last_name LIKE %s "
            "OR d.department_name LIKE %s OR c.course_name LIKE %s"
        )
        params.extend([like, like, like, like, like])
        sql += ")"

    sql += " ORDER BY s.usn"
    cursor.execute(sql, tuple(params))
    return [dict(row) for row in cursor.fetchall()]


def get_student(cursor: MySQLCursor, student_id: int) -> dict | None:
    """Return a single student record by id, or ``None``."""
    cursor.execute(_LIST_STUDENTS_SQL + " WHERE s.student_id = %s LIMIT 1", (student_id,))
    row = cursor.fetchone()
    return dict(row) if row else None


def get_student_by_usn(cursor: MySQLCursor, usn: str) -> dict | None:
    """Return a student by USN, or ``None``."""
    cursor.execute(
        _LIST_STUDENTS_SQL + " WHERE s.usn = %s LIMIT 1",
        (usn,),
    )
    row = cursor.fetchone()
    return dict(row) if row else None


def create_student(
    cursor: MySQLCursor,
    *,
    user_id: int,
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
) -> int:
    """Insert a student row and return the new ``student_id``."""
    cursor.execute(
        """
        INSERT INTO students
            (user_id, department_id, course_id, usn, first_name, last_name,
             date_of_birth, gender, email, phone, address_line1, city, state,
             pincode, admission_year, current_semester, status)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (
            user_id,
            department_id,
            course_id,
            usn,
            first_name,
            last_name,
            date_of_birth,
            gender,
            email,
            phone,
            address_line1,
            city,
            state,
            pincode,
            admission_year,
            current_semester,
            status,
        ),
    )
    return int(cursor.lastrowid)


def update_student(
    cursor: MySQLCursor,
    student_id: int,
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
    status: str,
) -> None:
    """Update an existing student row."""
    cursor.execute(
        """
        UPDATE students
        SET department_id = %s, course_id = %s, usn = %s, first_name = %s,
            last_name = %s, date_of_birth = %s, gender = %s, email = %s,
            phone = %s, address_line1 = %s, city = %s, state = %s,
            pincode = %s, admission_year = %s, current_semester = %s,
            status = %s, updated_at = CURRENT_TIMESTAMP
        WHERE student_id = %s
        """,
        (
            department_id,
            course_id,
            usn,
            first_name,
            last_name,
            date_of_birth,
            gender,
            email,
            phone,
            address_line1,
            city,
            state,
            pincode,
            admission_year,
            current_semester,
            status,
            student_id,
        ),
    )


def delete_student(cursor: MySQLCursor, student_id: int) -> None:
    """Delete a student row by id."""
    cursor.execute("DELETE FROM students WHERE student_id = %s", (student_id,))


def list_departments(cursor: MySQLCursor) -> list[dict]:
    """Return active departments for dropdowns."""
    cursor.execute(
        "SELECT department_id, department_code, department_name "
        "FROM departments WHERE status = 'active' ORDER BY department_code"
    )
    return [dict(row) for row in cursor.fetchall()]


def list_courses(cursor: MySQLCursor) -> list[dict]:
    """Return active courses for dropdowns."""
    cursor.execute(
        "SELECT course_id, course_code, course_name, department_id "
        "FROM courses WHERE status = 'active' ORDER BY course_code"
    )
    return [dict(row) for row in cursor.fetchall()]