#!/usr/bin/env python
r"""
GM University Management System — Admin Password Reset Utility

SECURE LOCAL DEVELOPMENT UTILITY — DO NOT USE IN PRODUCTION

Resets the password for the admin account (user_id = 1, login_identifier =
admin@gmail.com) without requiring the old password.

Usage:
    cd backend
    .venv\\Scripts\\python.exe reset_admin_password.py

Steps performed:
  1. Creates a logical SQL backup of the gmu_management_system database.
  2. Loads the existing Flask configuration (.env) for DB connection details.
  3. Verifies the admin account exists and has the admin role.
  4. Prompts you to enter a new password securely (not echoed to screen).
  5. Hashes the password using Werkzeug's generate_password_hash (same
     approach used by the application's authentication service).
  6. Updates only the password_hash field for user_id = 1 using a
     parameterized SQL query.
  7. Verifies the new hash using check_password_hash.
  8. All other account fields and database records are preserved.

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

TARGET_USER_ID = 1
EXPECTED_LOGIN_IDENTIFIER = "admin@gmail.com"
EXPECTED_ROLE_CODE = "admin"

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


def verify_admin_account(cursor) -> bool:
    """Verify that user_id = 1 exists and has the admin role."""
    cursor.execute(
        """
        SELECT u.user_id, u.login_identifier, r.role_code
        FROM users AS u
        JOIN roles AS r ON r.role_id = u.role_id
        WHERE u.user_id = %s
        """,
        (TARGET_USER_ID,),
    )
    row = cursor.fetchone()
    if row is None:
        print("ERROR: No account found with user_id = 1.")
        return False

    if row[1] != EXPECTED_LOGIN_IDENTIFIER:
        print(
            f"ERROR: Account user_id = 1 has login_identifier "
            f"'{row[1]}', expected '{EXPECTED_LOGIN_IDENTIFIER}'."
        )
        return False

    if row[2] != EXPECTED_ROLE_CODE:
        print(
            f"ERROR: Account user_id = 1 has role '{row[2]}', "
            f"expected '{EXPECTED_ROLE_CODE}'."
        )
        return False

    print(
        f"Verified admin account: user_id={row[0]}, "
        f"login_identifier='{row[1]}', role='{row[2]}'"
    )
    return True


def reset_password() -> None:
    """Main reset procedure."""
    print("=" * 60)
    print("GM UNIVERSITY MANAGEMENT SYSTEM — ADMIN PASSWORD RESET")
    print("=" * 60)
    print()

    # Step 1: Create backup
    print("[1/6] Creating database backup...")
    backup_path = create_backup()
    print(f"    Backup saved to: {backup_path}")
    print()

    # Step 2: Connect and verify admin account
    print("[2/6] Verifying admin account...")
    conn = mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
    )
    cursor = conn.cursor()

    if not verify_admin_account(cursor):
        cursor.close()
        conn.close()
        sys.exit(1)
    print()

    # Step 3: Prompt for new password securely
    print("[3/6] Enter new password for admin account...")
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

    # Step 4: Hash the password using Werkzeug (same as app)
    print("[4/6] Hashing password...")
    new_hash = generate_password_hash(password)
    # Zero out the plaintext password from memory as soon as possible
    password = None
    confirm = None
    print("    Password hashed successfully.")
    print()

    # Step 5: Update only password_hash using parameterized SQL
    print("[5/6] Updating password_hash for user_id = 1...")
    cursor.execute(
        "UPDATE users SET password_hash = %s WHERE user_id = %s",
        (new_hash, TARGET_USER_ID),
    )
    conn.commit()
    print("    Password hash updated.")
    print()

    # Step 6: Verify the new hash works
    print("[6/6] Verifying new password hash...")
    cursor.execute(
        "SELECT password_hash FROM users WHERE user_id = %s",
        (TARGET_USER_ID,),
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
    print("ADMIN PASSWORD RESET COMPLETE")
    print("=" * 60)
    print(
        f"The admin account (user_id = 1, login_identifier = "
        f"'{EXPECTED_LOGIN_IDENTIFIER}') now has a new password."
    )
    print("All other account fields and database records are preserved.")
    print(f"A backup was created at: {backup_path}")
    print("=" * 60)


if __name__ == "__main__":
    reset_password()