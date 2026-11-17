"""Regression checks for role-specific shells and prototype path isolation.

These tests use fake sessions and static file reads only. They do not connect to
or modify the university database.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DASHBOARD_DIR = ROOT / "frontend" / "dashboard"
APP_SHELL = ROOT / "frontend" / "static" / "js" / "app-shell.js"

EXPECTED_PAGES = {
    "admin": {
        "index", "students", "faculty", "users", "departments", "courses",
        "subjects", "semesters", "enrolments", "attendance", "marks", "fees",
        "feedback", "reports",
    },
    "faculty": {
        "index", "subjects", "students", "attendance", "marks-entry",
        "semester-marks", "performance", "reports", "notifications", "profile",
    },
    "student": {
        "index", "courses", "attendance", "assessments", "results", "fees",
        "timetable", "notifications", "feedback", "profile",
    },
}


def _body_attrs(text: str) -> dict[str, str]:
    match = re.search(r"<body\b([^>]*)>", text, re.I | re.S)
    if not match:
        return {}
    return dict(re.findall(r'(data-[a-z-]+)\s*=\s*"([^"]*)"', match.group(1), re.I))


def test_every_role_page_declares_its_own_shell():
    for role, expected_pages in EXPECTED_PAGES.items():
        pages = sorted((DASHBOARD_DIR / role).glob("*.html"))
        assert {path.stem for path in pages} == expected_pages

        for path in pages:
            text = path.read_text(encoding="utf-8")
            attrs = _body_attrs(text)
            assert attrs.get("data-role") == role, path
            assert attrs.get("data-page") in expected_pages, path
            for key in ("data-title", "data-subtitle", "data-breadcrumb"):
                assert attrs.get(key), (path, key)
            assert "app-shell.js" in text, path


def test_admin_faculty_and_faculty_students_keep_their_role_pages():
    admin_faculty = _body_attrs(
        (DASHBOARD_DIR / "admin" / "faculty.html").read_text(encoding="utf-8")
    )
    assert admin_faculty["data-role"] == "admin"
    assert admin_faculty["data-page"] == "faculty"
    assert admin_faculty["data-title"] == "Faculty Management"

    faculty_students = _body_attrs(
        (DASHBOARD_DIR / "faculty" / "students.html").read_text(encoding="utf-8")
    )
    assert faculty_students["data-role"] == "faculty"
    assert faculty_students["data-page"] == "students"
    assert faculty_students["data-title"] == "Student Management"


def test_shell_navigation_targets_exist():
    script = APP_SHELL.read_text(encoding="utf-8")
    for role in EXPECTED_PAGES:
        start = script.index(f"    {role}: {{")
        later = [
            script.index(f"    {other}: {{")
            for other in EXPECTED_PAGES
            if script.index(f"    {other}: {{") > start
        ]
        block = script[start:min(later or [len(script)])]
        for href in re.findall(r'\{\s*page:\s*"[^"]+",\s*href:\s*"([^"]+)"', block):
            assert (DASHBOARD_DIR / role / href).is_file(), (role, href)


def test_shell_restores_mobile_toggle_and_sample_notice():
    script = APP_SHELL.read_text(encoding="utf-8")
    assert 'data-nav-toggle' in script
    assert "buildDemoNotice" in script
    assert 'style="display:none"' not in script


def _login(client, role: str) -> None:
    with client.session_transaction() as session:
        session["user_id"] = 1
        session["role"] = role
        session["role_name"] = role.title()
        session["display_name"] = "Test User"
        session["login_identifier"] = "TEST-USER"
        session["_csrf_token"] = "test-token"


def test_prototype_pages_render_the_matching_role(client):
    for role, pages in EXPECTED_PAGES.items():
        _login(client, role)
        for page in pages:
            response = client.get(f"/prototype/dashboard/{role}/{page}.html")
            assert response.status_code == 200, (role, page)
            assert f'data-role="{role}"' in response.get_data(as_text=True)


def test_prototype_blocks_cross_role_and_traversal(client):
    _login(client, "admin")

    assert client.get("/prototype/dashboard/faculty/index.html").status_code == 403
    assert client.get("/prototype/dashboard/student/index.html").status_code == 403

    traversal_urls = (
        "/prototype/dashboard/admin/%2e%2e/student/index.html",
        "/prototype/dashboard/student/%2e%2e/admin/index.html",
        "/prototype/dashboard/student/%2e%2e/%2e%2e/templates/login.html",
        "/prototype/dashboard/admin/../../templates/login.html",
    )
    for url in traversal_urls:
        response = client.get(url)
        assert response.status_code == 404, url
        assert b"{{" not in response.data, url
