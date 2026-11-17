"""Read-only queries that back the authenticated role landing pages."""

from __future__ import annotations

from mysql.connector.cursor import MySQLCursor


def admin_summary(cursor: MySQLCursor) -> dict[str, int]:
    cursor.execute(
        """
        SELECT
            (SELECT COUNT(*) FROM students) AS students,
            (SELECT COUNT(*) FROM faculty) AS faculty,
            (SELECT COUNT(*) FROM departments) AS departments,
            (SELECT COUNT(*) FROM courses) AS courses,
            (SELECT COUNT(*) FROM users WHERE is_active = 1) AS active_users,
            (SELECT COUNT(*) FROM student_enrolments) AS enrolments
        """
    )
    row = cursor.fetchone() or {}
    return {key: int(value) for key, value in row.items()}


def student_profile(cursor: MySQLCursor, student_id: int) -> dict | None:
    cursor.execute(
        """
        SELECT usn, student_name, email, current_semester, student_status,
               department_code, department_name, course_code, course_name,
               login_identifier, account_status
        FROM vw_student_profile
        WHERE student_id = %s
        LIMIT 1
        """,
        (student_id,),
    )
    return cursor.fetchone()


def student_overview(cursor: MySQLCursor, student_id: int) -> dict[str, int | float]:
    cursor.execute(
        """
        SELECT
            (SELECT COUNT(*) FROM student_enrolments
              WHERE student_id = %s) AS enrolled_subjects,
            (SELECT COUNT(*) FROM attendance_records AS a
              JOIN student_enrolments AS e ON e.enrolment_id = a.enrolment_id
              WHERE e.student_id = %s) AS attendance_records,
            (SELECT COUNT(*) FROM fee_payments
              WHERE student_id = %s) AS payments,
            (SELECT COALESCE(SUM(amount_paid), 0) FROM fee_payments
              WHERE student_id = %s AND payment_status = 'success') AS total_paid
        """,
        (student_id, student_id, student_id, student_id),
    )
    row = cursor.fetchone() or {}
    return {
        "enrolled_subjects": int(row.get("enrolled_subjects", 0)),
        "attendance_records": int(row.get("attendance_records", 0)),
        "payments": int(row.get("payments", 0)),
        "total_paid": float(row.get("total_paid", 0)),
    }


def faculty_profile(cursor: MySQLCursor, faculty_id: int) -> dict | None:
    cursor.execute(
        """
        SELECT f.employee_id,
               CONCAT_WS(' ', f.first_name, f.last_name) AS faculty_name,
               d.department_name,
               COUNT(w.subject_code) AS assignment_count,
               COALESCE(SUM(w.enrolled_students), 0) AS enrolled_students
        FROM faculty AS f
        JOIN departments AS d ON d.department_id = f.department_id
        LEFT JOIN vw_faculty_workload AS w
               ON w.faculty_id = f.faculty_id AND w.assignment_active = 1
        WHERE f.faculty_id = %s
        GROUP BY f.faculty_id, f.employee_id, f.first_name, f.last_name,
                 d.department_name
        LIMIT 1
        """,
        (faculty_id,),
    )
    return cursor.fetchone()


def faculty_assignments(cursor: MySQLCursor, faculty_id: int) -> list[dict]:
    cursor.execute(
        """
        SELECT subject_code, subject_name, semester_number, academic_year,
               section, enrolled_students
        FROM vw_faculty_workload
        WHERE faculty_id = %s
        ORDER BY academic_year DESC, semester_number, subject_code
        """,
        (faculty_id,),
    )
    return list(cursor.fetchall())
