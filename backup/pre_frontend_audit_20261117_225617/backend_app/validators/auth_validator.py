"""Server-side validation for the login form."""

from __future__ import annotations

MAX_IDENTIFIER_LENGTH = 100
MAX_PASSWORD_LENGTH = 200

GENERIC_LOGIN_ERROR = (
    "Those details did not match an active account. Check your university "
    "login ID and password, then try again."
)


def validate_login(identifier: str, password: str) -> list[str]:
    """Return safe field messages; never echo the submitted password."""
    errors: list[str] = []

    if not identifier.strip():
        errors.append("Enter your university login ID.")
    elif len(identifier.strip()) > MAX_IDENTIFIER_LENGTH:
        errors.append("That university login ID is too long.")

    if not password:
        errors.append("Enter your password.")
    elif len(password) > MAX_PASSWORD_LENGTH:
        errors.append("That password is too long.")

    return errors
