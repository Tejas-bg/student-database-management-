"""Session, CSRF, and authorization helpers.

Authorization is enforced here, on the server, for every protected route.
"""

from __future__ import annotations

import secrets
from functools import wraps
from typing import Callable, Iterable
from urllib.parse import urlsplit

from flask import abort, redirect, request, session, url_for

CSRF_SESSION_KEY = "_csrf_token"
CSRF_FORM_FIELD = "csrf_token"


def csrf_token() -> str:
    """Return the per-session CSRF token, creating it when absent."""
    token = session.get(CSRF_SESSION_KEY)
    if not token:
        token = secrets.token_urlsafe(32)
        session[CSRF_SESSION_KEY] = token
    return token


def validate_csrf() -> None:
    """Reject state-changing requests without a matching token."""
    if request.method not in {"POST", "PUT", "PATCH", "DELETE"}:
        return

    expected = session.get(CSRF_SESSION_KEY)
    supplied = request.form.get(CSRF_FORM_FIELD) or request.headers.get("X-CSRF-Token")

    if not expected or not supplied or not secrets.compare_digest(expected, supplied):
        abort(400, description="Your form session expired. Reload the page and try again.")


def safe_redirect_target(target: str | None) -> str | None:
    """Allow only same-site relative paths, preventing open redirects."""
    if not target:
        return None
    target = target.strip()
    if not target.startswith("/") or target.startswith("//"):
        return None
    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc:
        return None
    return target


def login_required(view: Callable) -> Callable:
    @wraps(view)
    def wrapped(*args, **kwargs):
        if not session.get("user_id"):
            return redirect(url_for("auth.login", next=request.full_path))
        return view(*args, **kwargs)

    return wrapped


def roles_required(*allowed_roles: str) -> Callable:
    """Require an authenticated session whose server-set role is allowed."""

    allowed: Iterable[str] = frozenset(allowed_roles)

    def decorator(view: Callable) -> Callable:
        @wraps(view)
        def wrapped(*args, **kwargs):
            if not session.get("user_id"):
                return redirect(url_for("auth.login", next=request.full_path))
            if session.get("role") not in allowed:
                abort(403)
            return view(*args, **kwargs)

        return wrapped

    return decorator


def start_session(user) -> None:
    """Rotate the session after successful authentication.

    Clears every previous session value and issues a fresh CSRF token bound to
    the new session. Session rotation must re-issue the CSRF token: clearing
    the session (including ``_csrf_token``) and redirecting to a state-changing
    form without a valid token makes ``validate_csrf`` reject the request with
    HTTP 400.
    """
    session.clear()
    session.permanent = True
    session[CSRF_SESSION_KEY] = secrets.token_urlsafe(32)
    session["user_id"] = user.user_id
    session["role"] = user.role_code
    session["role_name"] = user.role_name
    session["display_name"] = user.display_name
    session["login_identifier"] = user.login_identifier
    session["student_id"] = user.student_id
    session["faculty_id"] = user.faculty_id
