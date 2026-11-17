"""Login flow tests with a mocked MySQL layer.

These tests exercise the real Flask routes, CSRF validation, session
rotation, and role-based redirects without requiring a running MySQL server.
``mysql.connector.connect`` and the authentication service are replaced with
fakes, so every test asserts behaviour of the application layer in isolation.

No real user passwords are modified, no accounts are created or deleted, and
no academic records are touched.
"""

from __future__ import annotations

from dataclasses import dataclass
from unittest.mock import MagicMock, patch

import pytest

from app import create_app
from app.auth.security import CSRF_SESSION_KEY
from app.models.user import User


def _make_user(role_code: str, role_name: str, user_id: int, **extra) -> User:
    return User(
        user_id=user_id,
        login_identifier=f"{role_code}001",
        email=f"{role_code}001@example.edu",
        password_hash="irrelevant-hash-mocked",
        account_status="active",
        is_active=True,
        must_change_password=False,
        role_code=role_code,
        role_name=role_name,
        display_name=f"Test {role_name}",
        student_id=extra.get("student_id"),
        faculty_id=extra.get("faculty_id"),
    )


ADMIN = _make_user("admin", "Administrator", 1)
FACULTY = _make_user("faculty", "Faculty", 2, faculty_id=201)
STUDENT = _make_user("student", "Student", 3, student_id=101)


class _FakeCursor:
    """Minimal dict-like cursor stand-in for dashboard repository queries."""

    def __init__(self, row=None, rows=None):
        self._row = row
        self._rows = rows or []

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def execute(self, sql, params=None):
        self.last_sql = sql
        self.last_params = params

    def fetchone(self):
        return self._row

    def fetchall(self):
        return list(self._rows)

    def close(self):
        pass


class _FakeConnection:
    """Minimal connection stand-in used by ``app.db.get_cursor``."""

    def __init__(self, row=None):
        self._row = row

    def cursor(self, dictionary=True):  # noqa: ARG002 - mirrors db.connect signature
        return _FakeCursor(self._row)

    def commit(self):
        pass

    def rollback(self):
        pass

    def close(self):
        pass


@pytest.fixture
def app():
    application = create_app(
        {
            "TESTING": True,
            "SECRET_KEY": "test-only-secret-key-not-for-production",
            "LOGIN_FAILURE_DELAY_SECONDS": 0.0,
            "SESSION_COOKIE_SECURE": False,
        }
    )
    yield application


@pytest.fixture
def client(app):
    return app.test_client()


def _patch_authenticate(mock_authenticate, user):
    """Configure the mocked ``authenticate`` to return ``user`` or ``None``."""
    mock_authenticate.return_value = user


def _dashboard_row_for(role_code: str):
    """Return a fake database row appropriate for the role's dashboard query."""
    if role_code == "admin":
        return {
            "students": 3,
            "faculty": 2,
            "departments": 1,
            "courses": 4,
            "active_users": 6,
            "enrolments": 10,
        }
    if role_code == "student":
        return {
            "usn": "1BM22CS001",
            "student_name": "Test Student",
            "email": "student001@example.edu",
            "current_semester": 4,
            "student_status": "active",
            "department_code": "CSE",
            "department_name": "Computer Science",
            "course_code": "CSE",
            "course_name": "Bachelor of Engineering",
            "login_identifier": "student001",
            "account_status": "active",
        }
    if role_code == "faculty":
        return {
            "employee_id": "F001",
            "faculty_name": "Test Faculty",
            "department_name": "Computer Science",
            "assignment_count": 2,
            "enrolled_students": 60,
        }
    return {}


def _login(client, user, password="secret", csrf_token=None, **extra_form):
    """POST to /login after loading the form (which seeds the CSRF token).

    Mirrors a real user: the login page is fetched first so the session holds
    a CSRF token, which is then submitted with the credentials.
    """
    if csrf_token is None:
        client.get("/login")
        with client.session_transaction() as session:
            csrf_token = session.get(CSRF_SESSION_KEY)
    return client.post(
        "/login",
        data={
            "identifier": user.login_identifier,
            "password": password,
            "csrf_token": csrf_token,
            **extra_form,
        },
    )


# ---------------------------------------------------------------------------
# Valid logins for each role
# ---------------------------------------------------------------------------


def test_valid_admin_login_redirects_to_dashboard(client, app):
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, ADMIN)
        response = _login(client, ADMIN)

    assert response.status_code == 302
    assert response.headers["Location"].endswith("/dashboard")

    with client.session_transaction() as session:
        assert session["user_id"] == ADMIN.user_id
        assert session["role"] == "admin"
        assert session["role_name"] == "Administrator"
        assert "password" not in session
        # Rotation re-issues a CSRF token bound to the new session.
        assert session.get(CSRF_SESSION_KEY)


def test_valid_faculty_login_redirects_to_dashboard(client, app):
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, FACULTY)
        response = _login(client, FACULTY)

    assert response.status_code == 302
    assert response.headers["Location"].endswith("/dashboard")

    with client.session_transaction() as session:
        assert session["user_id"] == FACULTY.user_id
        assert session["role"] == "faculty"
        assert session["role_name"] == "Faculty"
        assert session.get(CSRF_SESSION_KEY)


def test_valid_student_login_redirects_to_dashboard(client, app):
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, STUDENT)
        response = _login(client, STUDENT)

    assert response.status_code == 302
    assert response.headers["Location"].endswith("/dashboard")

    with client.session_transaction() as session:
        assert session["user_id"] == STUDENT.user_id
        assert session["role"] == "student"
        assert session["role_name"] == "Student"
        assert session.get(CSRF_SESSION_KEY)


def test_each_role_dashboard_renders_after_login(client, app):
    """Successful login lands each role on its own dashboard (HTTP 200)."""
    cases = [
        ("admin", ADMIN, "Administrator dashboard"),
        ("faculty", FACULTY, "Faculty dashboard"),
        ("student", STUDENT, "Student dashboard"),
    ]
    for role_code, user, expected_title in cases:
        with patch("app.routes.auth.authenticate") as mock_authenticate:
            _patch_authenticate(mock_authenticate, user)
            _login(client, user)

        dashboard_row = _dashboard_row_for(role_code)
        with patch(
            "mysql.connector.connect", return_value=_FakeConnection(row=dashboard_row)
        ):
            response = client.get("/dashboard")

        assert response.status_code == 200, f"{role_code} dashboard: {response.status_code}"
        body = response.get_data(as_text=True)
        assert expected_title in body, f"{role_code} dashboard missing title"
        assert f"Signed in as <strong>{user.display_name}</strong>" in body

        # Fresh session for the next role.
        with client.session_transaction() as session:
            session.clear()


# ---------------------------------------------------------------------------
# Authentication failures (generic messages, no enumeration)
# ---------------------------------------------------------------------------


def test_wrong_password_returns_generic_401(client, app):
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, None)
        response = _login(client, ADMIN, password="definitely-wrong")

    assert response.status_code == 401
    body = response.get_data(as_text=True)
    assert "did not match an active account" in body
    assert "unknown user" not in body.lower()
    assert "incorrect password" not in body.lower()


def test_unknown_identifier_returns_generic_401(client, app):
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, None)
        response = _login(
            client,
            ADMIN,
            identifier="NO-SUCH-ACCOUNT",
            password="whatever",
        )

    assert response.status_code == 401
    body = response.get_data(as_text=True)
    assert "did not match an active account" in body


# ---------------------------------------------------------------------------
# Missing input
# ---------------------------------------------------------------------------


def test_missing_login_fields_return_400(client, app):
    # Seed a valid CSRF token by loading the form, then submit empty fields.
    client.get("/login")
    with client.session_transaction() as session:
        csrf_token = session.get(CSRF_SESSION_KEY)

    response = client.post(
        "/login",
        data={"identifier": "", "password": "", "csrf_token": csrf_token},
    )
    assert response.status_code == 400
    body = response.get_data(as_text=True)
    assert "Enter your university login ID." in body
    assert "Enter your password." in body


# ---------------------------------------------------------------------------
# CSRF validation (protection preserved)
# ---------------------------------------------------------------------------


def test_login_without_csrf_token_is_rejected(client, app):
    """A state-changing POST without a CSRF token returns HTTP 400."""
    response = client.post(
        "/login",
        data={"identifier": ADMIN.login_identifier, "password": "secret"},
    )
    assert response.status_code == 400
    assert "session expired" in response.get_data(as_text=True).lower()


def test_login_with_invalid_csrf_token_is_rejected(client, app):
    """A state-changing POST with a wrong CSRF token returns HTTP 400."""
    with client.session_transaction() as session:
        session[CSRF_SESSION_KEY] = "real-token"

    response = client.post(
        "/login",
        data={
            "identifier": ADMIN.login_identifier,
            "password": "secret",
            "csrf_token": "wrong-token",
        },
    )
    assert response.status_code == 400
    assert "session expired" in response.get_data(as_text=True).lower()


def test_session_rotation_reissues_csrf_token(client, app):
    """After login the rotated session holds a valid CSRF token (no dangling 400)."""
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, ADMIN)
        before = _login(client, ADMIN)

    assert before.status_code == 302
    with client.session_transaction() as session:
        token = session.get(CSRF_SESSION_KEY)
        assert session["user_id"] == ADMIN.user_id
        assert token is not None

    # A subsequent state-changing request with the rotated token must not 400.
    response = client.post("/logout", data={"csrf_token": token})
    assert response.status_code == 302  # logged out cleanly, not rejected
    with client.session_transaction() as session:
        assert "user_id" not in session


# ---------------------------------------------------------------------------
# Session lifecycle
# ---------------------------------------------------------------------------


def test_anonymous_dashboard_redirects_to_login(client):
    response = client.get("/dashboard")
    assert response.status_code == 302
    assert "/login" in response.headers["Location"]


def test_logout_then_relogin_works(client, app):
    """Logout destroys the session and a fresh login succeeds afterwards."""
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, ADMIN)
        _login(client, ADMIN)

    with client.session_transaction() as session:
        assert session.get("user_id") == ADMIN.user_id
        logout_token = session.get(CSRF_SESSION_KEY)

    response = client.post("/logout", data={"csrf_token": logout_token})
    assert response.status_code == 302
    with client.session_transaction() as session:
        assert "user_id" not in session

    # Fresh login after logout: a new CSRF token is issued for the new session.
    with patch("app.routes.auth.authenticate") as mock_authenticate:
        _patch_authenticate(mock_authenticate, ADMIN)
        response = _login(client, ADMIN)

    assert response.status_code == 302
    assert response.headers["Location"].endswith("/dashboard")
    with client.session_transaction() as session:
        assert session["user_id"] == ADMIN.user_id
        assert session.get(CSRF_SESSION_KEY) != logout_token
