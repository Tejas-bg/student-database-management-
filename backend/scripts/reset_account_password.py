#!/usr/bin/env python
"""Reset an existing active GMU account from the local operator terminal."""

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
BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

PROJECT_ROOT = BACKEND_DIR.parent
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

ROLE_ADMIN = "admin"
ROLE_STUDENT = "student"
ROLE_FACULTY = "faculty"

# Known account identifiers (identifiers only, never passwords).
ADMIN_LOGIN_IDENTIFIER = "admin@gmail.com"
FACULTY_LOGIN_IDENTIFIERS = ("FAC-CSE-014", "FAC-CSE-021")
STUDENT_LOGIN_IDENTIFIERS = ("1GM23CS045", "1GM23CS052")

MIN_PASSWORD_LENGTH = 8

BACKUP_DIR = PROJECT_ROOT / "backup"
BACKUP_DIR.mkdir(exist_ok=True)


def validate_password_strength(password: str) -> str | None:
    """Return a message when a new password does not meet the local policy."""
    if len(password) < MIN_PASSWORD_LENGTH:
        return f"Password must be at least {MIN_PASSWORD_LENGTH} characters long."
    if len(password) > 200:
        return "Password must be no more than 200 characters long."
    if not any(char.isupper() for char in password):
        return "Password must contain at least one uppercase letter."
    if not any(char.islower() for char in password):
        return "Password must contain at least one lowercase letter."
    if not any(char.isdigit() for char in password):
        return "Password must contain at least one digit."
    if not any(not char.isalnum() for char in password):
        return "Password must contain at least one special character."
    return None


def create_backup() -> str:
    """Create a logical SQL backup of the database before making changes."""
    conn = mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )
    cursor = conn.cursor()

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup_path = BACKUP_DIR / f"gmu_management_system_backup_{timestamp}.sql"

    # Never overwrite an existing backup.
    if backup_path.exists():
        counter = 1
        while True:
            candidate = BACKUP_DIR / f"gmu_management_system_backup_{timestamp}_{counter}.sql"
            if not candidate.exists():
                backup_path = candidate
                break
            counter += 1

    cursor.execute(
        "SELECT TABLE_NAME FROM information_schema.TABLES "
        "WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE' "
        "ORDER BY TABLE_NAME",
        (DB_NAME,),
    )
    tables = [row[0] for row in cursor.fetchall()]

    if not tables:
        cursor.close()
        conn.close()
        raise RuntimeError("Backup failed: no tables found in the database.")

    with open(backup_path, "w", encoding="utf-8") as f:
        f.write("-- GM University Management System - Pre-reset backup\n")
        f.write(f"-- Created: {datetime.now().isoformat()}\n")
        f.write(f"-- Database: {DB_NAME}\n\n")
        f.write("SET FOREIGN_KEY_CHECKS = 0;\n\n")

        for table in tables:
            cursor.execute(f"SHOW CREATE TABLE `{table}`")
            create_table = cursor.fetchone()[1]
            f.write(f"-- Table: {table}\n")
            f.write(f"DROP TABLE IF EXISTS `{table}`;\n")
            f.write(f"{create_table};\n\n")

            cursor.execute(f"SELECT * FROM `{table}`")
            rows = cursor.fetchall()
            if rows:
                cursor.execute(f"DESCRIBE `{table}`")
                columns = [col[0] for col in cursor.fetchall()]
                col_list = ", ".join(f"`{col}`" for col in columns)

                for row in rows:
                    values = []
                    for val in row:
                        if val is None:
                            values.append("NULL")
                        elif isinstance(val, bool):
                            values.append("1" if val else "0")
                        elif isinstance(val, str):
                            escaped = val.replace("\\", "\\\\").replace("'", "''")
                            values.append(f"'{escaped}'")
                        elif isinstance(val, datetime):
                            values.append(f"'{val.isoformat(sep=' ')}'")
                        elif hasattr(val, "isoformat"):
                            values.append(f"'{val.isoformat()}'")
                        elif isinstance(val, bytes):
                            values.append(f"0x{val.hex()}")
                        elif isinstance(val, (int, float)):
                            values.append(str(val))
                        else:
                            escaped = str(val).replace("'", "''")
                            values.append(f"'{escaped}'")
                    f.write(
                        f"INSERT INTO `{table}` ({col_list}) VALUES ({', '.join(values)});\n"
                    )
            f.write("\n")

        f.write("SET FOREIGN_KEY_CHECKS = 1;\n")
        f.write("-- End of backup\n")

    cursor.close()
    conn.close()

    # Verify the backup actually succeeded.
    if not backup_path.exists() or backup_path.stat().st_size == 0:
        raise RuntimeError("Backup failed: backup file is missing or empty.")
    return str(backup_path)


def find_account_by_identifier(cursor, role_code: str, identifier: str) -> dict | None:
    """Find one account using its role-specific login identifier."""
    if role_code == ROLE_ADMIN:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.account_status,
                   u.is_active, r.role_code
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            WHERE u.login_identifier = %s AND r.role_code = %s
            """,
            (identifier, role_code),
        )
    elif role_code == ROLE_STUDENT:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.account_status,
                   u.is_active, r.role_code, s.first_name, s.last_name
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            JOIN students AS s ON s.user_id = u.user_id
            WHERE s.usn = %s AND r.role_code = %s
            """,
            (identifier, role_code),
        )
    elif role_code == ROLE_FACULTY:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email, u.account_status,
                   u.is_active, r.role_code, f.first_name, f.last_name
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            JOIN faculty AS f ON f.user_id = u.user_id
            WHERE f.employee_id = %s AND r.role_code = %s
            """,
            (identifier, role_code),
        )
    else:
        return None

    row = cursor.fetchone()
    if row is None:
        return None
    columns = [description[0] for description in cursor.description]
    return dict(zip(columns, row))


def persist_password_change(*args, **kwargs) -> bool:
    """Hash, store, verify and commit a new password for one user.

    The database connection may be passed explicitly to avoid relying on
    cursor-specific attributes such as ``cursor.connection``.
    """
    cursor = kwargs.get("cursor")
    connection = kwargs.get("connection")
    user_id = kwargs.get("user_id")
    password = kwargs.get("password")

    for arg in args:
        if cursor is None and hasattr(arg, "execute") and hasattr(arg, "fetchone"):
            cursor = arg
        elif connection is None and hasattr(arg, "commit") and hasattr(arg, "rollback"):
            connection = arg
        elif user_id is None and isinstance(arg, int) and not isinstance(arg, bool):
            user_id = arg
        elif password is None and isinstance(arg, str):
            password = arg

    if cursor is None:
        raise TypeError("A database cursor is required.")
    if connection is None:
        connection = getattr(cursor, "connection", None)
    if connection is None:
        raise RuntimeError("A database connection is required.")
    if user_id is None or password is None:
        raise TypeError("user_id and password are required.")

    committed = False
    try:
        password_hash = generate_password_hash(password)
        cursor.execute(
            "UPDATE users SET password_hash = %s WHERE user_id = %s",
            (password_hash, user_id),
        )
        cursor.execute(
            "SELECT password_hash FROM users WHERE user_id = %s",
            (user_id,),
        )
        row = cursor.fetchone()
        if row is None:
            connection.rollback()
            return False

        stored_hash = row["password_hash"] if isinstance(row, dict) else row[0]
        if not check_password_hash(stored_hash, password):
            connection.rollback()
            return False

        connection.commit()
        committed = True
        return True
    except Exception:
        connection.rollback()
        raise
    finally:
        if not committed:
            pass


def _prompt_for_new_password() -> str | None:
    while True:
        try:
            password = getpass.getpass("New password (input hidden): ")
            confirmation = getpass.getpass("Confirm password: ")
        except (EOFError, KeyboardInterrupt):
            print("\nPassword reset cancelled.")
            return None

        if password != confirmation:
            print("Passwords do not match. Try again.")
            continue

        error = validate_password_strength(password)
        if error:
            print(error)
            continue
        return password


def reset_password_for_account(cursor, account: dict, connection=None) -> bool:
    """Confirm and reset one active account."""
    display_name = account.get("first_name") or account["login_identifier"]
    if account.get("last_name"):
        display_name = f"{display_name} {account['last_name']}"

    print("\nAccount to update:")
    print(f"  Role: {account['role_code']}")
    print(f"  Identifier: {account['login_identifier']}")
    print(f"  Name: {display_name}")
    print()

    try:
        confirm = input("Proceed with password reset? (yes/no): ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print("\nPassword reset cancelled.")
        return False
    if confirm != "yes":
        print("Password reset cancelled.")
        return False

    password = _prompt_for_new_password()
    if password is None:
        return False

    try:
        if connection is None:
            updated = persist_password_change(cursor, int(account["user_id"]), password)
        else:
            updated = persist_password_change(cursor, connection, int(account["user_id"]), password)
    except mysql.connector.Error as error:
        print(f"Database update failed; the change was rolled back: {error}")
        return False

    if not updated:
        print("Password verification failed; no change was committed.")
        return False

    print("Password updated and verified successfully.")
    print(f"Account: {account['login_identifier']}")
    return True


def _is_active(account: dict) -> bool:
    return (
        account["is_active"] == 1
        and account["account_status"] in ("active", "pending_reset")
    )


def reset_admin_password(cursor, connection=None) -> None:
    """Reset an active administrator by the registered login ID."""
    cursor.execute(
        """
        SELECT u.login_identifier
        FROM users AS u
        JOIN roles AS r ON r.role_id = u.role_id
        WHERE r.role_code = %s
          AND u.is_active = 1
          AND u.account_status IN ('active', 'pending_reset')
        ORDER BY u.login_identifier
        """,
        (ROLE_ADMIN,),
    )
    identifiers = [row[0] for row in cursor.fetchall()]
    if not identifiers:
        print("No active administrator accounts are available.")
        return

    print("Active administrator login IDs:")
    for identifier in identifiers:
        print(f"  {identifier}")
    try:
        identifier = input("Enter the administrator login ID: ").strip()
    except (EOFError, KeyboardInterrupt):
        print("\nPassword reset cancelled.")
        return

    account = find_account_by_identifier(cursor, ROLE_ADMIN, identifier)
    if account is None or not _is_active(account):
        print("No active administrator account matched that login ID.")
        return
    reset_password_for_account(cursor, account, connection)


def reset_student_password(cursor, connection=None) -> None:
    """Reset an active student by USN."""
    try:
        identifier = input("Enter student USN: ").strip()
    except (EOFError, KeyboardInterrupt):
        print("\nPassword reset cancelled.")
        return

    account = find_account_by_identifier(cursor, ROLE_STUDENT, identifier)
    if account is None or not _is_active(account):
        print("No active student account matched that USN.")
        return
    reset_password_for_account(cursor, account, connection)


def reset_faculty_password(cursor, connection=None) -> None:
    """Reset an active faculty member by employee ID."""
    try:
        identifier = input("Enter faculty Employee ID: ").strip()
    except (EOFError, KeyboardInterrupt):
        print("\nPassword reset cancelled.")
        return

    account = find_account_by_identifier(cursor, ROLE_FACULTY, identifier)
    if account is None or not _is_active(account):
        print("No active faculty account matched that Employee ID.")
        return
    reset_password_for_account(cursor, account, connection)


def main() -> int:
    """Run the operator menu using the Flask application's database config."""
    try:
        from app import create_app
        from app.db import get_connection

        app = create_app()
    except RuntimeError as error:
        print(error)
        return 1

    if app.config["DB_NAME"] != "gmu_management_system":
        print("Refusing to run: DB_NAME is not gmu_management_system.")
        return 1

    try:
        with app.app_context():
            # Create a verified backup before any password change.
            print("Creating database backup...")
            backup_path = create_backup()
            print(f"Backup saved to: {backup_path}")
            print()

            with get_connection() as connection:
                cursor = connection.cursor()
                try:
                    while True:
                        print("\nGMU ACCOUNT PASSWORD MANAGER")
                        print("1. Reset Administrator Password")
                        print("2. Reset Student Password")
                        print("3. Reset Faculty Password")
                        print("4. Exit")
                        try:
                            choice = input("Select an option: ").strip()
                        except (EOFError, KeyboardInterrupt):
                            print("\nCancelled.")
                            break

                        if choice == "1":
                            reset_admin_password(cursor, connection)
                        elif choice == "2":
                            reset_student_password(cursor, connection)
                        elif choice == "3":
                            reset_faculty_password(cursor, connection)
                        elif choice == "4":
                            print("Exiting.")
                            break
                        else:
                            print("Invalid option. Please select 1-4.")
                finally:
                    cursor.close()
    except mysql.connector.Error as error:
        print(f"Database operation failed: {error}")
        return 1
    except RuntimeError as error:
        print(error)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
