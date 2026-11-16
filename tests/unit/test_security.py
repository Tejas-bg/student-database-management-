"""Unit tests for CSRF-safe redirect handling and password sentinels."""

from __future__ import annotations

import pytest

from app.auth.security import safe_redirect_target
from app.services.auth_service import verify_password


@pytest.mark.parametrize(
    ("target", "expected"),
    [
        ("/dashboard", "/dashboard"),
        ("/prototype/dashboard/student/index.html", "/prototype/dashboard/student/index.html"),
        ("//evil.example", None),
        ("https://evil.example", None),
        ("javascript:alert(1)", None),
        ("", None),
        (None, None),
    ],
)
def test_safe_redirect_target(target, expected):
    assert safe_redirect_target(target) == expected


def test_sentinel_hash_never_authenticates():
    assert verify_password("!NO_LOGIN_HASH_SET", "anything") is False


def test_malformed_hash_never_raises():
    assert verify_password("not-a-valid-hash", "anything") is False
