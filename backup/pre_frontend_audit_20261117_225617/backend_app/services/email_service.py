"""Email service for sending password reset emails via SMTP.

Reads SMTP configuration from environment variables. If SMTP is not
configured, raises a clear error instead of silently failing.
"""

from __future__ import annotations

import os
import smtplib
from email.message import EmailMessage

SMTP_HOST = os.environ.get("SMTP_HOST", "").strip()
SMTP_PORT = int(os.environ.get("SMTP_PORT", "587"))
SMTP_USER = os.environ.get("SMTP_USER", "").strip()
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD", "").strip()
SMTP_FROM_EMAIL = os.environ.get("SMTP_FROM_EMAIL", "noreply@gmu.edu.in").strip()
SMTP_FROM_NAME = os.environ.get("SMTP_FROM_NAME", "GM University Management System").strip()


def is_configured() -> bool:
    """Return True if SMTP credentials are fully configured."""
    return bool(SMTP_HOST and SMTP_USER and SMTP_PASSWORD)


def send_password_reset_email(to_email: str, reset_url: str) -> None:
    """Send a password reset email to the given address.

    Raises ``RuntimeError`` if SMTP is not configured.
    """
    if not is_configured():
        raise RuntimeError(
            "SMTP is not configured. Set SMTP_HOST, SMTP_USER, and SMTP_PASSWORD "
            "in .env to enable password reset emails."
        )

    subject = "Password Reset - GM University Management System"
    body = (
        f"You requested a password reset for your GM University Management System account.\n\n"
        f"Click the link below to reset your password:\n\n{reset_url}\n\n"
        f"This link expires in 15 minutes. If you did not request this reset, "
        f"please ignore this email.\n\n"
        f"---\n{SMTP_FROM_NAME}"
    )

    msg = EmailMessage()
    msg["From"] = f"{SMTP_FROM_NAME} <{SMTP_FROM_EMAIL}>"
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.set_content(body)

    with smtplib.SMTP(SMTP_HOST, SMTP_PORT, timeout=10) as server:
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)
        server.send_message(msg)