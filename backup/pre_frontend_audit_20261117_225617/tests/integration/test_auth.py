"""Integration tests for authentication, sessions, CSRF, and RBAC."""

from __future__ import annotations

from tests.conftest import TEST_LOGIN, TEST_PASSWORD


def test_health_reports_live_mysql(client):
    response = client.get("/health")
    assert response.status_code == 200
    payload = response.get_json()
    assert payload["status"] == "ok"
    assert payload["database"] == "connected"
    assert payload["version"].startswith("8.")


def test_login_page_renders_with_csrf(client):
    response = client.get("/login")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "Sign in to your account" in body
    assert 'name="csrf_token"' in body
    assert 'name="role"' not in body  # no role selector, ever


def test_protected_dashboard_redirects_anonymous_user(client):
    response = client.get("/dashboard")
    assert response.status_code == 302
    assert "/login" in response.headers["Location"]


def test_post_without_csrf_is_rejected(client):
    response = client.post(
        "/login",
        data={"identifier": TEST_LOGIN, "password": TEST_PASSWORD},
    )
    assert response.status_code == 400
    assert "session expired" in response.get_data(as_text=True).lower()


def test_empty_fields_are_rejected(csrf_client):
    response = csrf_client.post(
        "/login",
        data={"identifier": "", "password": "", "csrf_token": "test-csrf-token"},
    )
    assert response.status_code == 400
    body = response.get_data(as_text=True)
    assert "Enter your university login ID." in body
    assert "Enter your password." in body


def test_wrong_password_is_generic(csrf_client):
    response = csrf_client.post(
        "/login",
        data={
            "identifier": TEST_LOGIN,
            "password": "definitely-wrong",
            "csrf_token": "test-csrf-token",
        },
    )
    assert response.status_code == 401
    body = response.get_data(as_text=True)
    assert "did not match an active account" in body
    assert "unknown user" not in body.lower()
    assert "incorrect password" not in body.lower()


def test_unknown_identifier_uses_the_same_message(csrf_client):
    response = csrf_client.post(
        "/login",
        data={
            "identifier": "NO-SUCH-ACCOUNT",
            "password": "whatever",
            "csrf_token": "test-csrf-token",
        },
    )
    assert response.status_code == 401
    assert "did not match an active account" in response.get_data(as_text=True)


def test_valid_login_starts_session_and_redirects(csrf_client, test_user):
    response = csrf_client.post(
        "/login",
        data={
            "identifier": test_user["login"],
            "password": test_user["password"],
            "csrf_token": "test-csrf-token",
        },
        follow_redirects=False,
    )
    assert response.status_code == 302
    assert response.headers["Location"].endswith("/dashboard")

    with csrf_client.session_transaction() as session:
        assert session["user_id"] == test_user["user_id"]
        assert session["role"] == "admin"
        assert "password" not in session


def test_admin_dashboard_uses_database_counts(csrf_client, test_user):
    csrf_client.post(
        "/login",
        data={
            "identifier": test_user["login"],
            "password": test_user["password"],
            "csrf_token": "test-csrf-token",
        },
    )
    response = csrf_client.get("/dashboard")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "Administrator dashboard" in body
    assert "Active users" in body


def test_role_check_blocks_cross_role_prototype(client):
    with client.session_transaction() as session:
        session["user_id"] = 999
        session["role"] = "student"
        session["role_name"] = "Student"
        session["display_name"] = "Test Student"

    allowed = client.get("/prototype/dashboard/student/index.html")
    blocked = client.get("/prototype/dashboard/admin/index.html")

    assert allowed.status_code == 200
    assert blocked.status_code == 403


def test_anonymous_prototype_request_redirects(client):
    response = client.get("/prototype/dashboard/admin/index.html")
    assert response.status_code == 302
    assert "/login" in response.headers["Location"]


def test_logout_destroys_session(csrf_client, test_user):
    csrf_client.post(
        "/login",
        data={
            "identifier": test_user["login"],
            "password": test_user["password"],
            "csrf_token": "test-csrf-token",
        },
    )
    with csrf_client.session_transaction() as session:
        session["_csrf_token"] = "logout-token"

    response = csrf_client.post("/logout", data={"csrf_token": "logout-token"})
    assert response.status_code == 302
    assert "signed_out=1" in response.headers["Location"]

    with csrf_client.session_transaction() as session:
        assert "user_id" not in session


def test_unknown_page_returns_safe_404(client):
    response = client.get("/no-such-page")
    assert response.status_code == 404
    body = response.get_data(as_text=True)
    assert "Page not found" in body
    assert "Traceback" not in body
