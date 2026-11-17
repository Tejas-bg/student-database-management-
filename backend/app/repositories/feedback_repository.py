"""Data access for student feedback and course/faculty relationships."""

from __future__ import annotations

from mysql.connector.cursor import MySQLCursor

FEEDBACK_CATEGORY_COURSE = "course"


def list_student_courses(cursor: MySQLCursor, student_id: int, semester_id: int | None = None) -> list[dict]:
    """Return subjects the student is enrolled in, joined with assigned faculty."""
    sql = """
        SELECT
            e.enrolment_id,
            e.student_id,
            e.subject_id,
            e.semester_id,
            e.section,
            e.status,
            s.usn,
            s.first_name,
            s.last_name,
            s.email,
            s.current_semester,
            sub.course_id,
            sub.subject_code,
            sub.subject_name,
            sub.semester_number,
            sub.subject_type,
            sub.credits,
            sub.status AS subject_status,
            c.course_code,
            c.course_name,
            f.faculty_id,
            f.employee_id,
            f.designation,
            f.first_name AS faculty_first_name,
            f.last_name AS faculty_last_name
        FROM student_enrolments AS e
        JOIN students AS s ON s.student_id = e.student_id
        JOIN subjects AS sub ON sub.subject_id = e.subject_id
        JOIN courses AS c ON c.course_id = sub.course_id
        LEFT JOIN faculty_subject_assignments AS fa
               ON fa.subject_id = e.subject_id
              AND fa.semester_id = e.semester_id
              AND fa.is_active = 1
        LEFT JOIN faculty AS f ON f.faculty_id = fa.faculty_id AND f.status = 'active'
        WHERE e.student_id = %s AND e.status = 'enrolled'
    """
    params: list = [student_id]
    if semester_id is not None:
        sql += " AND e.semester_id = %s"
        params.append(semester_id)
    sql += " ORDER BY e.semester_id, sub.course_code, sub.subject_code"
    cursor.execute(sql, tuple(params))
    return [dict(row) for row in cursor.fetchall()]


def list_faculty_for_subject(cursor: MySQLCursor, subject_id: int, semester_id: int) -> list[dict]:
    """Return active faculty assignments for a subject in a semester."""
    cursor.execute(
        """
        SELECT fa.assignment_id, fa.faculty_id, f.employee_id, f.designation,
               f.first_name, f.last_name, f.status AS faculty_status,
               fa.section, fa.is_active, fa.assigned_on
        FROM faculty_subject_assignments AS fa
        JOIN faculty AS f ON f.faculty_id = fa.faculty_id
        WHERE fa.subject_id = %s
          AND fa.semester_id = %s
          AND fa.is_active = 1
        ORDER BY fa.faculty_id
        """,
        (subject_id, semester_id),
    )
    return [dict(row) for row in cursor.fetchall()]


def get_enrolment(cursor: MySQLCursor, student_id: int, subject_id: int) -> dict | None:
    """Return the student's active enrolment for a subject, if any."""
    cursor.execute(
        """
        SELECT enrolment_id, student_id, subject_id, semester_id, section, status
        FROM student_enrolments
        WHERE student_id = %s AND subject_id = %s AND status = 'enrolled'
        ORDER BY enrolment_id DESC
        LIMIT 1
        """,
        (student_id, subject_id),
    )
    row = cursor.fetchone()
    return dict(row) if row else None


def find_feedback(cursor: MySQLCursor, student_id: int, subject_id: int, semester_id: int) -> dict | None:
    """Return an existing course-feedback row for the student/subject/semester."""
    cursor.execute(
        """
        SELECT feedback_id, student_id, subject_id, faculty_id, semester_id, category,
               rating, comments, is_anonymous, status
        FROM feedback
        WHERE student_id = %s AND subject_id = %s AND semester_id = %s
          AND category = %s
        ORDER BY feedback_id DESC
        LIMIT 1
        """,
        (student_id, subject_id, semester_id, FEEDBACK_CATEGORY_COURSE),
    )
    row = cursor.fetchone()
    return dict(row) if row else None


def insert_feedback(
    cursor: MySQLCursor,
    *,
    student_id: int,
    subject_id: int,
    faculty_id: int,
    semester_id: int,
    rating: int,
    comments: str,
    is_anonymous: bool,
) -> int:
    """Insert a course feedback submission."""
    cursor.execute(
        """
        INSERT INTO feedback
            (student_id, subject_id, faculty_id, semester_id, category, rating,
             comments, is_anonymous, status, submitted_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'submitted', NOW())
        """,
        (
            student_id,
            subject_id,
            faculty_id,
            semester_id,
            FEEDBACK_CATEGORY_COURSE,
            rating,
            comments,
            int(bool(is_anonymous)),
        ),
    )
    return int(cursor.lastrowid)
