"""MySQL integration checks for the local demo-account setup utility."""

from __future__ import annotations

from dataclasses import replace
from secrets import token_hex

import pytest
from werkzeug.security import check_password_hash

from app.db import get_connection
from app.repositories.user_repository import find_by_identifier
from scripts.create_sample_student_account import (
    SAMPLE_STUDENT,
    create_sample_student_account,
    validate_password,
)
from tests.conftest import TEST_PASSWORD


@pytest.mark.parametrize(
    "password",
    ["short", "alllowercase1!", "ALLUPPERCASE1!", "NoDigits!!"],
)
def test_sample_account_password_policy_rejects_weak_passwords(password):
    with pytest.raises(ValueError):
        validate_password(password)


def test_sample_student_is_created_atomically_and_duplicate_is_rejected(app):
    suffix = token_hex(4).upper()
    account = replace(
        SAMPLE_STUDENT,
        login_identifier=f"TEST-SETUP-{suffix}",
        usn=f"TEST-{suffix}",
        email=f"test.setup.{suffix.lower()}@example.edu",
        first_name="Test",
        last_name="Setup",
    )

    with app.app_context():
        with get_connection() as connection:
            cursor = connection.cursor(dictionary=True)
            try:
                connection.start_transaction()
                student_id = create_sample_student_account(
                    cursor,
                    account,
                    TEST_PASSWORD,
                )
                cursor.execute(
                    """
                    SELECT u.password_hash, u.account_status, u.is_active,
                           s.usn, s.student_id
                    FROM users AS u
                    JOIN students AS s ON s.user_id = u.user_id
                    WHERE u.login_identifier = %s
                    """,
                    (account.login_identifier,),
                )
                row = cursor.fetchone()
                assert row is not None
                assert row["student_id"] == student_id
                assert row["usn"] == account.usn
                assert row["account_status"] == "active"
                assert row["is_active"] == 1
                assert check_password_hash(row["password_hash"], TEST_PASSWORD)
                user = find_by_identifier(cursor, account.usn)
                assert user is not None
                assert user.role_code == "student"
                assert user.is_login_allowed

                with pytest.raises(ValueError, match="already exists"):
                    create_sample_student_account(cursor, account, TEST_PASSWORD)
            finally:
                connection.rollback()
                cursor.close()

        with get_connection() as connection:
            cursor = connection.cursor()
            try:
                cursor.execute(
                    "SELECT COUNT(*) FROM users WHERE login_identifier = %s",
                    (account.login_identifier,),
                )
                assert cursor.fetchone()[0] == 0
            finally:
                cursor.close()
