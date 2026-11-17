#!/usr/bin/env python
"""Create the fictional 1GM23CS052 demo account in the local MySQL database."""

from __future__ import annotations

import getpass
import sys
from dataclasses import dataclass
from pathlib import Path

import mysql.connector
from werkzeug.security import generate_password_hash

BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app import create_app
from app.db import get_connection
from app.repositories.student_repository import create_student


@dataclass(frozen=True)
class StudentAccount:
    """Fictional student and login details used by the local demo setup."""

    login_identifier: str
    usn: str
    email: str
    first_name: str
    last_name: str
    date_of_birth: str
    gender: str
    phone: str
    admission_year: int
    current_semester: int
    department_code: str
    course_code: str


SAMPLE_STUDENT = StudentAccount(
    login_identifier="1GM23CS052",
    usn="1GM23CS052",
    email="diya.nair.student@example.edu",
    first_name="Diya",
    last_name="Nair",
    date_of_birth="2005-09-03",
    gender="female",
    phone="9000000052",
    admission_year=2023,
    current_semester=6,
    department_code="CSE",
    course_code="BTECH-CSE",
)


def validate_password(password: str) -> None:
    """Reject passwords that do not meet the local account policy."""
    if len(password) < 8:
        raise ValueError("Password must be at least 8 characters long.")
    if len(password) > 200:
        raise ValueError("Password must be no more than 200 characters long.")
    if not any(char.isupper() for char in password):
        raise ValueError("Password must contain an uppercase letter.")
    if not any(char.islower() for char in password):
        raise ValueError("Password must contain a lowercase letter.")
    if not any(char.isdigit() for char in password):
        raise ValueError("Password must contain a number.")
    if not any(not char.isalnum() for char in password):
        raise ValueError("Password must contain a special character.")


def create_sample_student_account(
    cursor,
    account: StudentAccount,
    password: str,
) -> int:
    """Insert a fictional student and active login; caller controls the transaction."""
    validate_password(password)

    cursor.execute(
        """
        SELECT
            EXISTS (
                SELECT 1
                FROM users
                WHERE login_identifier = %s OR email = %s
            ) AS user_conflict,
            EXISTS (
                SELECT 1
                FROM students
                WHERE usn = %s OR email = %s
            ) AS student_conflict
        """,
        (account.login_identifier, account.email, account.usn, account.email),
    )
    conflicts = cursor.fetchone()
    if conflicts["user_conflict"] or conflicts["student_conflict"]:
        raise ValueError(
            "The sample login ID, USN, or email already exists. No data was changed."
        )

    cursor.execute(
        "SELECT role_id FROM roles WHERE role_code = %s",
        ("student",),
    )
    role = cursor.fetchone()
    if role is None:
        raise ValueError("The student role is missing from this database.")

    cursor.execute(
        """
        SELECT d.department_id, c.course_id
        FROM departments AS d
        JOIN courses AS c ON c.department_id = d.department_id
        WHERE d.department_code = %s
          AND c.course_code = %s
          AND d.status = 'active'
          AND c.status = 'active'
        """,
        (account.department_code, account.course_code),
    )
    programme = cursor.fetchone()
    if programme is None:
        raise ValueError(
            "The active CSE department and BTECH-CSE course must exist first."
        )

    cursor.execute(
        """
        INSERT INTO users
            (role_id, login_identifier, email, password_hash, account_status,
             is_active, must_change_password, password_changed_at)
        VALUES (%s, %s, %s, %s, 'active', 1, 0, CURRENT_TIMESTAMP)
        """,
        (
            role["role_id"],
            account.login_identifier,
            account.email,
            generate_password_hash(password),
        ),
    )
    user_id = int(cursor.lastrowid)

    return create_student(
        cursor,
        user_id=user_id,
        department_id=int(programme["department_id"]),
        course_id=int(programme["course_id"]),
        usn=account.usn,
        first_name=account.first_name,
        last_name=account.last_name,
        date_of_birth=account.date_of_birth,
        gender=account.gender,
        email=account.email,
        phone=account.phone,
        address_line1=None,
        city=None,
        state=None,
        pincode=None,
        admission_year=account.admission_year,
        current_semester=account.current_semester,
    )


def _prompt_for_password() -> str:
    while True:
        password = getpass.getpass("New password (input hidden): ")
        confirmation = getpass.getpass("Confirm password: ")
        if password != confirmation:
            print("Passwords do not match. Try again.")
            continue
        try:
            validate_password(password)
        except ValueError as error:
            print(error)
            continue
        return password


def main() -> int:
    """Confirm and create the fictional account in the configured local DB."""
    app = create_app()
    config = app.config

    if config["DB_NAME"] != "gmu_management_system":
        print("Refusing to run: DB_NAME is not gmu_management_system.")
        return 1

    print("This will add one fictional student account to the configured database.")
    print(
        f"Database: {config['DB_HOST']}:{config['DB_PORT']}/{config['DB_NAME']}"
    )
    print(f"Login ID: {SAMPLE_STUDENT.login_identifier}")
    if input("Continue? Type yes to proceed: ").strip().lower() != "yes":
        print("Cancelled; no data was changed.")
        return 0

    password = _prompt_for_password()
    try:
        with app.app_context():
            with get_connection() as connection:
                cursor = connection.cursor(dictionary=True)
                try:
                    connection.start_transaction()
                    student_id = create_sample_student_account(
                        cursor,
                        SAMPLE_STUDENT,
                        password,
                    )
                    connection.commit()
                except (ValueError, mysql.connector.Error):
                    connection.rollback()
                    raise
                finally:
                    cursor.close()
    except ValueError as error:
        print(f"Could not create the sample account: {error}")
        return 1
    except mysql.connector.Error as error:
        print(f"MySQL operation failed; the transaction was rolled back: {error}")
        return 1

    print("Sample student account created successfully.")
    print(f"Login ID: {SAMPLE_STUDENT.login_identifier}")
    print(f"Student record ID: {student_id}")
    print("The password was stored as a hash; it was not printed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
