#!/usr/bin/env python
"""Set one operator-chosen temporary password for active local demo accounts."""

from __future__ import annotations

import getpass
import sys
from pathlib import Path

import mysql.connector
from werkzeug.security import check_password_hash, generate_password_hash

BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app import create_app
from app.db import get_connection

ROLES = ("admin", "student", "faculty")


def validate_password(password: str) -> None:
    """Require a strong password before applying a bulk local reset."""
    if len(password) < 12:
        raise ValueError("Password must be at least 12 characters long.")
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


def _row_value(row, key=None):
    if isinstance(row, dict):
        if key in row:
            return row[key]
        return next(iter(row.values()))
    return row[0]


def fetch_account_ids(cursor) -> dict[str, list[int]]:
    """Return active, non-locked account IDs grouped by role."""
    result: dict[str, list[int]] = {role: [] for role in ROLES}
    for role in ROLES:
        cursor.execute(
            """
            SELECT u.user_id
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            WHERE r.role_code = %s
              AND u.is_active = 1
              AND u.account_status IN ('active', 'pending_reset')
            ORDER BY u.user_id
            """,
            (role,),
        )
        result[role] = [int(_row_value(row, "user_id")) for row in cursor.fetchall()]
    return result


def update_accounts(
    cursor,
    account_ids: dict[str, list[int]],
    password_hash: str,
) -> dict[str, int]:
    """Update password hashes for the supplied account IDs."""
    counts = {role: 0 for role in ROLES}
    for role in ROLES:
        for user_id in account_ids.get(role, []):
            cursor.execute(
                "UPDATE users SET password_hash = %s WHERE user_id = %s",
                (password_hash, user_id),
            )
            if cursor.rowcount != 1:
                raise RuntimeError(f"Password update failed for user_id {user_id}.")
            counts[role] += 1
    return counts


def verify_account_hashes(cursor, account_ids: dict[str, list[int]], password: str) -> bool:
    """Verify every updated account against the operator-supplied password."""
    for role in ROLES:
        for user_id in account_ids.get(role, []):
            cursor.execute(
                "SELECT password_hash FROM users WHERE user_id = %s",
                (user_id,),
            )
            row = cursor.fetchone()
            if row is None:
                return False
            stored_hash = _row_value(row, "password_hash")
            if not check_password_hash(stored_hash, password):
                return False
    return True


def set_demo_passwords(
    connection,
    cursor,
    *,
    password: str,
    confirm: bool = True,
) -> dict | None:
    """Reset active demo accounts transactionally; never persist plain text."""
    validate_password(password)
    account_ids = fetch_account_ids(cursor)
    total = sum(len(ids) for ids in account_ids.values())
    if total == 0:
        raise RuntimeError("No active demo accounts were found to update.")

    if confirm:
        answer = input(
            f"This will set one shared temporary password for {total} active account(s) "
            f"({len(account_ids['admin'])} admin, "
            f"{len(account_ids['student'])} student, "
            f"{len(account_ids['faculty'])} faculty). "
            "Type YES to continue: "
        ).strip()
        if answer != "YES":
            return None

    password_hash = generate_password_hash(password)
    # End the implicit transaction opened by account-selection SELECTs.
    connection.commit()
    connection.start_transaction()
    try:
        counts = update_accounts(cursor, account_ids, password_hash)
        if any(counts[role] != len(account_ids[role]) for role in ROLES):
            raise RuntimeError("Affected account count mismatch; rolling back.")
        if not verify_account_hashes(cursor, account_ids, password):
            raise RuntimeError("Password hash verification failed; rolling back.")
        connection.commit()
    except Exception:
        connection.rollback()
        raise

    return {"account_ids": account_ids, "counts": counts}


def _prompt_for_password() -> str | None:
    while True:
        try:
            password = getpass.getpass("New shared temporary password (hidden): ")
            confirmation = getpass.getpass("Confirm password: ")
        except (EOFError, KeyboardInterrupt):
            print("\nCancelled.")
            return None

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
    """Run the operator-confirmed bulk reset using the Flask DB configuration."""
    try:
        app = create_app()
    except RuntimeError as error:
        print(error)
        return 1

    if app.config["DB_NAME"] != "gmu_management_system":
        print("Refusing to run: DB_NAME is not gmu_management_system.")
        return 1

    try:
        with app.app_context():
            with get_connection() as connection:
                cursor = connection.cursor(dictionary=True)
                try:
                    account_ids = fetch_account_ids(cursor)
                    print("Accounts selected for a shared temporary password:")
                    for role in ROLES:
                        print(f"  {role}: {len(account_ids[role])}")
                    password = _prompt_for_password()
                    if password is None:
                        return 0
                    result = set_demo_passwords(
                        connection,
                        cursor,
                        password=password,
                        confirm=True,
                    )
                finally:
                    cursor.close()
    except (RuntimeError, ValueError, mysql.connector.Error) as error:
        print(f"Operation failed; changes were rolled back: {error}")
        return 1

    if result is None:
        print("Cancelled; no data was changed.")
        return 0

    counts = result["counts"]
    print("\nTemporary password reset completed successfully.")
    print(f"  Administrators updated: {counts['admin']}")
    print(f"  Students updated:       {counts['student']}")
    print(f"  Faculty updated:        {counts['faculty']}")
    print("All selected accounts share the password you entered. Rotate it after the demo.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
