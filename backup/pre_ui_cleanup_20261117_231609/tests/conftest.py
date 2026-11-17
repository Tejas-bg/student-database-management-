"""Shared pytest fixtures.

The suite runs against the real MySQL database configured in ``.env``.
It creates one disposable test account and removes it afterwards.
"""

from __future__ import annotations

import sys
from pathlib import Path

import mysql.connector
import pytest
from werkzeug.security import generate_password_hash

PROJECT_ROOT = Path(__file__).resolve().parents[1]
BACKEND_DIR = PROJECT_ROOT / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app import create_app  # noqa: E402

TEST_LOGIN = "TEST-AUTH-9001"
TEST_PASSWORD = "TestOnly#2026"


def _db_connect(app):
    config = app.config
    return mysql.connector.connect(
        host=config["DB_HOST"],
        port=config["DB_PORT"],
        user=config["DB_USER"],
        password=config["DB_PASSWORD"],
        database=config["DB_NAME"],
        autocommit=False,
    )


@pytest.fixture(scope="session")
def app():
    application = create_app(
        {
            "TESTING": True,
            "SECRET_KEY": "test-only-secret-key-not-for-production",
            "LOGIN_FAILURE_DELAY_SECONDS": 0.0,
        }
    )
    yield application


@pytest.fixture(scope="session")
def test_user(app):
    """Create a disposable administrator account, then remove it."""
    connection = _db_connect(app)
    try:
        cursor = connection.cursor()
        cursor.execute("SELECT role_id FROM roles WHERE role_code = 'admin'")
        role_id = cursor.fetchone()[0]
        cursor.execute("DELETE FROM users WHERE login_identifier = %s", (TEST_LOGIN,))
        cursor.execute(
            """
            INSERT INTO users
                (role_id, login_identifier, email, password_hash, account_status,
                 is_active, must_change_password)
            VALUES (%s, %s, %s, %s, 'active', 1, 0)
            """,
            (
                role_id,
                TEST_LOGIN,
                "test.auth.9001@example.edu",
                generate_password_hash(TEST_PASSWORD),
            ),
        )
        connection.commit()
        user_id = cursor.lastrowid
        cursor.close()
    finally:
        connection.close()

    yield {"user_id": user_id, "login": TEST_LOGIN, "password": TEST_PASSWORD}

    connection = _db_connect(app)
    try:
        cursor = connection.cursor()
        cursor.execute("DELETE FROM users WHERE login_identifier = %s", (TEST_LOGIN,))
        connection.commit()
        cursor.close()
    finally:
        connection.close()


@pytest.fixture
def client(app):
    return app.test_client()


@pytest.fixture
def csrf_client(client):
    """A client whose session already holds a known CSRF token."""
    with client.session_transaction() as session:
        session["_csrf_token"] = "test-csrf-token"
    return client
