#!/usr/bin/env python
r"""
GM University Management System — Student Password Reset Utility

SECURE LOCAL DEVELOPMENT UTILITY — DO NOT USE IN PRODUCTION

Resets the password for an existing student account without requiring
the old password. Does NOT change the USN, does NOT create a new account,
and only updates the password_hash field.

Usage:
    cd backend
    .venv\\Scripts\\python.exe reset_student_password.py

Steps performed:
  1. Creates a logical SQL backup of the gmu_management_system database.
  2. Loads the existing Flask configuration (.env) for DB connection details.
  3. Lists all student accounts for selection.
  4. Prompts you to select a student by student_id.
  5. Verifies the selected account exists and has the student role.
  6. Prompts you to enter a new password securely (not echoed to screen).
  7. Hashes the password using Werkzeug's generate_password_hash (same
     approach used by the application's authentication service).
  8. Updates only the password_hash field using a parameterized SQL query.
  9. Verifies the new hash using check_password_hash.
 10. Preserves USN, email, role, account status, and all other fields.

No passwords or password hashes are printed, logged, or exposed.
"""

from __future__ import annotations

import getpass
import os
import sys
from datetime import datetime
from pathlib import Path

from dotenv import load_dotenv
from werkzeug.security import check_password_hash, generate_password_hash

# ---------------------------------------------------------------------------
# Load project configuration (same as the Flask application)
# ---------------------------------------------------------------------------
PROJECT_ROOT = Path(__file__).resolve().parent.parent
BACKEND_DIR = PROJECT_ROOT / "backend"
sys.path.insert(0, str(BACKEND_DIR))

load_dotenv(PROJECT_ROOT / ".env")

import mysql.connector  # noqa: E402  (import after path setup)

# ---------------------------------------------------------------------------
# Configuration (read from environment, matching Flask config.py)
# ---------------------------------------------------------------------------
DB_HOST = os.environ.get("DB_HOST", "127.0.0.1")
DB_PORT = int(os.environ.get("DB_PORT", "3307"))
DB_NAME = os.environ.get("DB_NAME", "gmu_management_system")
DB_USER = os.environ.get("DB_USER", "root")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")

EXPECTED_ROLE_CODE = "student"

BACKUP_DIR = PROJECT_ROOT / "backup"
BACKUP_DIR.mkdir(exist_ok=True)


def create_backup() -> str:
    """Create a logical SQL backup of the database before making changes."""
    import mysql.connector as mc

    conn = mc.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )
    cursor = conn.cursor()

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = BACKUP_DIR / f"gmu_management_system_backup_{timestamp}.sql"

    cursor.execute(
        "SELECT TABLE_NAME FROM information_schema.TABLES "
        "WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE' "
        "ORDER BY TABLE_NAME",
        (DB_NAME,),
    )
    tables = [row[0] for row in cursor.fetchall()]

    with open(backup_path, "w", encoding="utf-8") as f:
        f.write(f"-- GM University Management System — Pre-reset backup\n")
        f.write(f"-- Created: {datetime.now().isoformat()}\n")
        f.write(f"-- Database: {DB_NAME}\n\n")
        f.write("SET FOREIGN_KEY_CHECKS = 0;\n\n")

        for table in tables:
            cursor.execute(f"SHOW CREATE TABLE {table}")
            create_table = cursor.fetchone()[1]
            f.write(f"-- Table: {table}\n")
            f.write(f"DROP TABLE IF EXISTS {table};\n")
            f.write(f"{create_table};\n\n")

            cursor.execute(f"SELECT * FROM {table}")
            rows = cursor.fetchall()
            if rows:
                cursor.execute(f"DESCRIBE {table}")
                columns = [col[0] for col in cursor.fetchall()]
                col_list = ", ".join(columns)

                for row in rows:
                    values = []
                    for val in row:
                        if val is None:
                            values.append("NULL")
                        elif isinstance(val, str):
                            escaped = val.replace("'", "''").replace("\\", "\\\\")
                            values.append(f"'{escaped}'")
                        elif isinstance(val, bytes):
                            values.append(f"0x{val.hex()}")
                        else:
                            values.append(str(val))
                    f.write(f"INSERT INTO {table} ({col_list}) VALUES ({', '.join(values)});\n")
            f.write("\n")

        f.write("SET FOREIGN_KEY_CHECKS = 1;\n")
        f.write("-- End of backup\n")

    cursor.close()
    conn.close()
    return str(backup_path)


def list_students(cursor) -> list:
    """Return all student accounts for selection."""
    cursor.execute(
        """
        SELECT u.user_id, u.login_identifier, u.email, u.password_hash,
               u.account_status, u.is_active, u.must_change_password,
               s.student_id, s.usn, s.first_name, s.last_name
        FROM users AS u
        JOIN roles AS r ON r.role_id = u.role_id
        JOIN students AS s ON s.user_id = u.user_id
        WHERE r.role_code = %s
        ORDER BY s.student_id
        """,
        (EXPECTED_ROLE_CODE,),
    )
    columns = [desc[0] for desc in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


def verify_student_account(cursor, student_id: int) -> dict | None:
    """Verify that the student account exists and return its details."""
    cursor.execute(
        """
        SELECT u.user_id, u.login_identifier, u.email, u.password_hash,
               u.account_status, u.is_active,
               s.student_id, s.usn, s.first_name, s.last_name
        FROM users AS u
        JOIN roles AS r ON r.role_id = u.role_id
        JOIN students AS s ON s.user_id = u.user_id
        WHERE s.student_id = %s AND r.role_code = %s
        """,
        (student_id, EXPECTED_ROLE_CODE),
    )
    row = cursor.fetchone()
    if row is None:
        return None
    columns = [desc[0] for desc in cursor.description]
    return dict(zip(columns, row))


def reset_password() -> None:
    """Main reset procedure."""
    print("=" * 60)
    print("GM UNIVERSITY MANAGEMENT SYSTEM — STUDENT PASSWORD RESET")
    print("=" * 60)
    print()

    # Step 1: Create backup
    print("[1/6] Creating database backup...")
    backup_path = create_backup()
    print(f"    Backup saved to: {backup_path}")
    print()

    # Step 2: Connect and list students
    print("[2/6] Listing student accounts...")
    conn = mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )
    cursor = conn.cursor()

    students = list_students(cursor)
    if not students:
        print("    No student accounts found.")
        cursor.close()
        conn.close()
        sys.exit(1)

    print(f"    Found {len(students)} student account(s):")
    print()
    for s in students:
        hash_type = "REAL HASH" if not s['password_hash'].startswith('!') else "SENTINEL"
        status = "active" if s['is_active'] else "inactive"
        print(f"  student_id={s['student_id']:2d}  USN={s['usn']:15s}  "
              f"name={s['first_name']} {s['last_name']:15s}  "
              f"status={status:8s}  hash={hash_type}")
    print()

    # Step 3: Select student
    print("[3/6] Select student account to reset...")
    while True:
        try:
            selection = input("Enter student_id: ").strip()
            student_id = int(selection)
        except ValueError:
            print("    Please enter a valid numeric student_id.")
            continue

        account = verify_student_account(cursor, student_id)
        if account is None:
            print(f"    No student account found with student_id={student_id}.")
            continue
        break

    print(f"    Selected: {account['first_name']} {account['last_name']} "
          f"(USN: {account['usn']}, user_id: {account['user_id']})")
    print()

    # Step 4: Prompt for new password securely
    print("[4/6] Enter new password for student account...")
    print("    (Input will not be displayed on screen)")
    while True:
        password = getpass.getpass("New password: ")
        if not password:
            print("    Password cannot be empty. Try again.")
            continue
        confirm = getpass.getpass("Confirm password: ")
        if password != confirm:
            print("    Passwords do not match. Try again.")
            continue
        break
    print()

    # Step 5: Hash and update (parameterized SQL, only password_hash field)
    print("[5/6] Hashing password and updating database...")
    new_hash = generate_password_hash(password)
    # Zero out plaintext password from memory immediately
    password = None
    confirm = None

    cursor.execute(
        "UPDATE users SET password_hash = %s WHERE user_id = %s",
        (new_hash, account['user_id']),
    )
    conn.commit()
    print("    password_hash updated (only field changed).")
    print()

    # Step 6: Verify the new hash works
    print("[6/6] Verifying new password hash...")
    cursor.execute(
        "SELECT password_hash FROM users WHERE user_id = %s",
        (account['user_id'],),
    )
    row = cursor.fetchone()
    stored_hash = row[0]

    # Re-prompt for verification (don't reuse the zeroed password)
    verify_password = getpass.getpass("Enter new password to verify: ")
    if check_password_hash(stored_hash, verify_password):
        print("    Password hash verified successfully.")
    else:
        print("    ERROR: Password hash verification failed!")
        cursor.close()
        conn.close()
        sys.exit(1)

    cursor.close()
    conn.close()

    print()
    print("=" * 60)
    print("STUDENT PASSWORD RESET COMPLETE")
    print("=" * 60)
    print(
        f"The student account (student_id={account['student_id']}, "
        f"USN={account['usn']}) now has a new password."
    )
    print("USN, email, role, account status, and all other fields are preserved.")
    print(f"A backup was created at: {backup_path}")
    print("=" * 60)


if __name__ == "__main__":
    reset_password()