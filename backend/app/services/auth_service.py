"""Authentication service: password verification and login bookkeeping."""

from __future__ import annotations

import os
import secrets
from datetime import datetime, timedelta, timezone

from werkzeug.security import check_password_hash, generate_password_hash

from app.db import get_cursor
from app.models.user import User
from app.repositories import user_repository
from app.services.email_service import send_password_reset_email, is_configured as is_smtp_configured


def verify_password(password_hash: str, password: str) -> bool:
    """Verify a Werkzeug hash without raising on sentinel or malformed values."""
    if not password_hash or password_hash.startswith("!"):
        # Seeded accounts use a non-authenticating sentinel, never a real hash.
        return False
    try:
        return check_password_hash(password_hash, password)
    except (ValueError, TypeError):
        return False


def authenticate(identifier: str, password: str) -> User | None:
    """Return an active user for valid credentials, otherwise ``None``.

    The same ``None`` result is returned for unknown, inactive, and
    wrong-password accounts so the caller cannot enumerate identifiers.
    """
    normalized = identifier.strip()

    with get_cursor(commit=True) as cursor:
        user = user_repository.find_by_identifier(cursor, normalized)
        if user is None:
            return None

        if not verify_password(user.password_hash, password):
            user_repository.record_failed_login(cursor, user.user_id)
            return None

        if not user.is_login_allowed:
            return None

        user_repository.record_successful_login(cursor, user.user_id)
        return user


def request_password_reset(email: str) -> bool:
    """Request a password reset for the given email address.

    Returns True if the reset email was sent (or would be sent in dev mode
    without SMTP), False otherwise. Never reveals whether the email exists
    in the database — always returns True to avoid email enumeration.
    """
    with get_cursor() as cursor:
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier
            FROM users AS u
            JOIN roles AS r ON r.role_id = u.role_id
            WHERE u.email = %s AND u.is_active = 1 AND u.account_status = 'active'
            LIMIT 1
            """,
            (email,),
        )
        row = cursor.fetchone()
        if row is None:
            # Email not found or inactive — still return True to avoid enumeration
            return True

        user_id = int(row["user_id"])
        login_identifier = row["login_identifier"]

        # Invalidate any existing unused tokens for this user
        user_repository.invalidate_password_reset_tokens(cursor, user_id)

        # Generate a secure random token
        token = secrets.token_urlsafe(32)
        token_hash = user_repository.hash_token(token)

        expires_at = datetime.now(timezone.utc) + timedelta(
            minutes=int(os.environ.get("PASSWORD_RESET_TOKEN_EXPIRY_MINUTES", "15"))
        )

        user_repository.create_password_reset_token(
            cursor, user_id, token_hash, expires_at
        )

    # Send email
    reset_url = f"{os.environ.get('APP_BASE_URL', 'http://127.0.0.1:5000')}/reset-password/{token}"
    try:
        if is_smtp_configured():
            send_password_reset_email(email, reset_url)
        else:
            # In development without SMTP, print to stdout (never expose token publicly)
            print(f"\n{'='*60}")
            print(f"PASSWORD RESET TOKEN (development only):")
            print(f"  User: {login_identifier} ({email})")
            print(f"  Token: {token}")
            print(f"  Reset URL: {reset_url}")
            print(f"{'='*60}\n")
    except Exception:
        # If email sending fails, we still return True to avoid enumeration
        # The token is still valid in the database
        pass

    return True


def verify_reset_token(token: str) -> dict | None:
    """Verify a password reset token and return the user info if valid.

    Returns a dict with user_id, login_identifier, email if valid, None otherwise.
    """
    token_hash = user_repository.hash_token(token)
    with get_cursor() as cursor:
        user_id = user_repository.consume_password_reset_token(cursor, token_hash)
        if user_id is None:
            return None
        # Get user details
        cursor.execute(
            """
            SELECT u.user_id, u.login_identifier, u.email
            FROM users AS u
            WHERE u.user_id = %s AND u.is_active = 1 AND u.account_status = 'active'
            LIMIT 1
            """,
            (user_id,),
        )
        row = cursor.fetchone()
        if row is None:
            return None
        return {
            "user_id": int(row["user_id"]),
            "login_identifier": row["login_identifier"],
            "email": row["email"],
        }


def reset_password_with_token(token: str, new_password: str) -> bool:
    """Reset a user's password using a valid reset token.

    Returns True on success, False if the token is invalid or expired.
    """
    user_info = verify_reset_token(token)
    if user_info is None:
        return False

    # Validate password strength
    if len(new_password) < 8:
        return False

    new_hash = generate_password_hash(new_password)

    with get_cursor(commit=True) as cursor:
        cursor.execute(
            """
            UPDATE users
            SET password_hash = %s,
                password_changed_at = NOW(),
                must_change_password = 0
            WHERE user_id = %s
            """,
            (new_hash, user_info["user_id"]),
        )

    return True
