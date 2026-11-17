"""Integration tests for the UI polish additions: personalized greetings,
server-backed dashboard search, CSRF token endpoint, and feedback authorization.

No real account passwords are reset, no academic records are touched, and the
disposable administrator fixture from ``tests.conftest`` is used only for login.
"""

from __future__ import annotations

from tests.conftest import TEST_LOGIN, TEST_PASSWORD


def _login_admin(client):
    response = client.post(
        "/login",
        data={
            "identifier": TEST_LOGIN,
            "password": TEST_PASSWORD,
            "csrf_token": "test-csrf-token",
        },
    )
    assert response.status_code == 302
    return response


def test_auth_me_returns_session_identity(csrf_client, test_user):
    _login_admin(csrf_client)
    response = csrf_client.get("/me")
    assert response.status_code == 200
    payload = response.get_json()
    assert payload["authenticated"] is True
    assert payload["user_id"] == test_user["user_id"]
    assert payload["role"] == "admin"
    assert isinstance(payload["display_name"], str)
    assert payload["display_name"]


def test_auth_me_rejects_anonymous_client(client):
    response = client.get("/me")
    assert response.status_code == 401
    assert response.get_json()["authenticated"] is False


def test_csrf_token_endpoint_issues_token(csrf_client):
    response = csrf_client.get("/csrf-token")
    assert response.status_code == 200
    body = response.get_json()
    assert isinstance(body["csrf_token"], str)
    assert body["csrf_token"]


def test_dashboard_search_returns_matching_students_as_admin(csrf_client, test_user):
    _login_admin(csrf_client)
    response = csrf_client.get("/dashboard/search?q=1GM23CS045&type=students")
    assert response.status_code == 200
    payload = response.get_json()
    assert payload["type"] == "students"
    assert payload["query"] == "1GM23CS045"
    assert isinstance(payload["results"], list)
    assert len(payload["results"]) >= 1
    first = payload["results"][0]
    assert first["usn"]


def test_dashboard_search_rejects_anonymous_client(client):
    response = client.get("/dashboard/search?q=1GM23CS045&type=students")
    assert response.status_code == 302
    assert "/login" in response.headers["Location"]


def test_feedback_endpoints_reject_non_student_roles(csrf_client, test_user):
    _login_admin(csrf_client)
    with csrf_client.session_transaction() as session:
        session["_csrf_token"] = "test-csrf-token"
    response = csrf_client.get("/feedback/courses")
    assert response.status_code == 403

    response = csrf_client.post(
        "/feedback",
        json={
            "subject_id": 1,
            "faculty_id": 1,
            "semester_id": 1,
            "rating": 5,
            "comments": "Automated check.",
        },
        headers={"X-CSRF-Token": "test-csrf-token"},
    )
    assert response.status_code == 403


def test_dashboard_renders_personalized_greeting(csrf_client, test_user):
    _login_admin(csrf_client)
    response = csrf_client.get("/dashboard")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "Signed in as" in body
    assert "Good " in body
