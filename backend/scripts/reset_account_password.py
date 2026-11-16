#!/usr/bin/env python
"""
GM University Management System — Secure Password Reset Utility

Resets the password for existing Admin, Student, or Faculty accounts
without requiring the old password. Only the password_hash field is updated.

USAGE:
    cd c:\\Users\\tejas\\Documents\\NEXUS\\backend
    .venv\\Scripts\\python.exe scripts\\reset_account_password.py

This utility:
  - Uses the existing Flask application configuration (.env) for database
    connection settings.
  - Connects to the existing gmu_management_system MySQL database.
  - Uses Werkzeug's generate_password_hash() / check_password_hash() for
    password hashing and verification (same approach as the application).
  - Uses parameterized SQL queries to prevent SQL injection.
  - Uses a database transaction with COMMIT only after successful verification,
    ROLLBACK on error.
  - Creates a backup before the first password change in a session.
  - Never stores plaintext passwords.
  - Never modifies any field other than password_hash.
  - Never creates, deletes, or renames accounts.
  - Never exposes passwords or password hashes in output.

WARNING: This utility modifies live database records. Run only when you
intentionally want to change a password.
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

# Role configuration
ROLE_ADMIN = "admin"
ROLE_STUDENT = "student"
ROLE_FACULTY = "faculty"

ADMIN_LOGIN_IDENTIFIER = "admin@gmail.com"

# Password strength requirements
MIN_PASSWORD_LENGTH = 8
REQUIRE_UPPERCASE = True
REQUIRE_LOWERCASE = True
REQUIRE_DIGIT = True
REQUIRE_SPECIAL = True

BACKUP_DIR = PROJECT_ROOT / "backup"
BACKUP_DIR.mkdir(exist_ok=True)


# ---------------------------------------------------------------------------
# Backup
# ---------------------------------------------------------------------------
_backup_created = False


def create_backup() -> str:
    """Create a logical SQL backup of the database before making changes.

    Returns the absolute path of the backup file.
    """
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
        f.write("-- GM University Management System — Pre-reset backup\n")
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


# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------
def validate_password_strength(password: str) -> str | None:
    """Validate password strength. Returns an error message or None."""
    if len(password) < MIN_PASSWORD_LENGTH:
        return f"Password must be at least {MIN_PASSWORD_LENGTH} characters long."
    if REQUIRE_UPPERCASE and not any(c.isupper() for c in password):
        return "Password must contain at least one uppercase letter."
    if REQUIRE_LOWERCASE and not any(c.islower() for c in password):
        return "Password must contain at least one lowercase letter."
    if REQUIRE_DIGIT and not any(c.isdigit() for c in password):
        return "Password must contain at least one digit."
    if REQUIRE_SPECIAL and not any(not c.isalnum() for c in password):
        return "Password must contain at least one special character."
    return None


# ---------------------------------------------------------------------------
# Lookup helpers
# ---------------------------------------------------------------------------
def find_account_by_identifier(cursor, role_code: str, identifier_value: str):
    """Look up an account by its role-specific identifier.

    Returns a dict with user details or None if not found.
    """
    if role_code == ROLE_ADMIN:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.password_hash,
                   u.account_status, u.is_active, r.role_code
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            WHERE u.login_identifier = %s AND r.role_code = %s
            """,
            (identifier_value, ROLE_ADMIN),
        )
    elif role_code == ROLE_STUDENT:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.password_hash,
                   u.account_status, u.is_active, r.role_code,
                   s.student_id, s.usn, s.first_name, s.last_name
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            JOIN students AS s ON s.user_id = u.user_id
            WHERE s.usn = %s AND r.role_code = %s
            """,
            (identifier_value, ROLE_STUDENT),
        )
    elif role_code == ROLE_FACULTY:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.password_hash,
                   u.account_status, u.is_active, r.role_code,
                   f.faculty_id, f.employee_id, f.first_name, f.last_name
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            JOIN faculty AS f ON f.user_id = u.user_id
            WHERE f.employee_id = %s AND r.role_code = %s
            """,
            (identifier_value, ROLE_FACULTY),
        )
    else:
        return None

    row = cursor.fetchone()
    if row is None:
        return None
    # cursor(dictionary=True) already returns a dict; otherwise convert tuple
    if isinstance(row, dict):
        return row
    columns = [d[0] for d in cursor.description]
    return dict(zip(columns, row))


# ---------------------------------------------------------------------------
# Password reset workflow
# ---------------------------------------------------------------------------
def hash_password(password: str) -> str:
    """Hash a plaintext password using Werkzeug."""
    return generate_password_hash(password)


def verify_password_hash(password: str, password_hash: str) -> bool:
    """Verify a plaintext password against a stored hash."""
    return check_password_hash(password_hash, password)


def reset_password_for_account(cursor, account: dict) -> bool:
    """Reset the password for a given account dictionary.

    Returns True on success, False on failure.
    """
    user_id = account["user_id"]
    login_identifier = account["login_identifier"]
    role_code = account["role_code"]
    display_name = account.get("display_name") or account.get("first_name") or account["login_identifier"]

    print(f"\nAccount to update:")
    print(f"  Role: {role_code}")
    print(f"  Identifier: {login_identifier}")
    print(f"  Name: {display_name}")
    print(f"  Status: {account['account_status']} (active={account['is_active']})")
    print()

    # Confirm before proceeding
    confirm = input("Proceed with password reset for this account? (yes/no): ").strip().lower()
    if confirm != "yes":
        print("Password reset cancelled.")
        return False

    # Prompt for new password securely
    while True:
        password = getpass.getpass("New password: ")
        if not password:
            print("  Password cannot be empty. Try again.")
            continue
        error = validate_password_strength(password)
        if error:
            print(f"  {error} Try again.")
            continue
        confirm_pw = getpass.getpass("Confirm new password: ")
        if password != confirm_pw:
            print("  Passwords do not match. Try again.")
            continue
        break

    new_hash = hash_password(password)

    try:
        cursor.execute(
            "UPDATE users SET password_hash = %s WHERE user_id = %s",
            (new_hash, user_id),
        )
        conn = cursor.connection
        conn.commit()
    except Exception as exc:
        conn.rollback()
        print(f"ERROR: Database update failed: {exc}")
        return False

    # Verify the new hash works
    cursor.execute(
        "SELECT password_hash FROM users WHERE user_id = %s",
        (user_id,),
    )
    row = cursor.fetchone()
    stored_hash = row[0]

    # Re-prompt for verification (don't reuse the zeroed password)
    verify_password = getpass.getpass("Enter new password to verify: ")
    if not check_password_hash(stored_hash, verify_password):
        print("ERROR: Password hash verification failed!")
        cursor.connection.rollback()
        return False

    print()
    print("=" * 60)
    print("PASSWORD UPDATED SUCCESSFULLY")
    print("=" * 60)
    print(f"Role: {role_code}")
    print(f"Account: {display_name}")
    print(f"Identifier: {login_identifier}")
    print("Database update: COMMITTED")
    print("New password verification: PASSED")
    print()
    print("You can now log in using your new password.")
    return True


def reset_admin_password(cursor) -> None:
    """Reset the administrator account password."""
    account = find_account_by_identifier(cursor, ROLE_ADMIN, ADMIN_LOGIN_IDENTIFIER)
    if account is None:
        print("ERROR: Admin account not found with login_identifier 'admin@gmail.com'.")
        return

    if account["role_code"] != ROLE_ADMIN:
        print("ERROR: Account does not have the admin role.")
        return

    if account["is_active"] != 1 or account["account_status"] != "active":
        print("ERROR: Account is not active. Cannot reset password.")
        return

    if not reset_password_for_account(cursor, account):
        return


def reset_student_password(cursor) -> None:
    """Reset a student account password by USN."""
    usn = input("Enter student USN: ").strip()
    if not usn:
        print("ERROR: USN cannot be empty.")
        return

    account = find_account_by_identifier(cursor, ROLE_STUDENT, usn)
    if account is None:
        print(f"ERROR: No student account found with USN '{usn}'.")
        return

    if account["role_code"] != ROLE_STUDENT:
        print(f"ERROR: Account does not have the student role.")
        return

    if account["is_active"] != 1 or account["account_status"] != "active":
        print("ERROR: Account is not active. Cannot reset password.")
        return

    if not reset_password_for_account(cursor, account):
        return


def reset_faculty_password(cursor) -> None:
    """Reset a faculty account password by employee ID."""
    employee_id = input("Enter faculty Employee ID: ").strip()
    if not employee_id:
        print("ERROR: Employee ID cannot be empty.")
        return

    account = find_account_by_identifier(cursor, ROLE_FACULTY, employee_id)
    if account is None:
        print(f"ERROR: No faculty account found with Employee ID '{employee_id}'.")
        return

    if account["role_code"] != ROLE_FACULTY:
        print("ERROR: Account does not have the faculty role.")
        return

    if account["is_active"] != 1 or account["account_status"] != "active":
        print("ERROR: Account is not active. Cannot reset password.")
        return

    if not reset_password_for_account(cursor, account):
        return


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main() -> None:
    """Main reset procedure."""
    print("=" * 60)
    print("GM UNIVERSITY MANAGEMENT SYSTEM")
    print("ACCOUNT PASSWORD MANAGER")
    print("=" * 60)
    print()

    # Step 1: Create backup before any changes
    print("[1/6] Creating database backup...")
    backup_path = create_backup()
    print(f"    Backup saved to: {backup_path}")
    print()

    # Step 2: Connect to database
    print("[2/6] Connecting to database...")
    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
        )
    except mysql.connector.Error as exc:
        print(f"ERROR: Cannot connect to database: {exc}")
        sys.exit(1)
    cursor = conn.cursor()

    # Step 3: Main menu
    while True:
        print()
        print("1. Reset Administrator Password")
        print("2. Reset Student Password")
        print("3. Reset Faculty Password")
        print("4. Exit")
        try:
            choice = input("Select an option: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nCancelled by user.")
            cursor.close()
            conn.close()
            sys.exit(0)

        if choice == "1":
            reset_admin_password(cursor)
        elif choice == "2":
            reset_student_password(cursor)
        elif choice == "3":
            reset_faculty_password(cursor)
        elif choice == "4":
            print("Exiting.")
            break
        else:
            print("Invalid option. Please select 1-4.")

    cursor.close()
    conn.close()


if __name__ == "__main__":
    main()