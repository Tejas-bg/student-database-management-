"""Application configuration read from environment variables.

Secrets live in the repository-root ``.env`` file, which is ignored by Git.
Nothing in this module contains a real credential.
"""

from __future__ import annotations

import os
from datetime import timedelta
from pathlib import Path

from dotenv import load_dotenv

BACKEND_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = BACKEND_DIR.parent
FRONTEND_DIR = PROJECT_ROOT / "frontend"
TEMPLATE_DIR = FRONTEND_DIR / "templates"
STATIC_DIR = FRONTEND_DIR / "static"

# Load the repository-root .env once, without overriding real environment values.
load_dotenv(PROJECT_ROOT / ".env")


def _as_bool(value: str | None, default: bool = False) -> bool:
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


class Config:
    """Base configuration shared by development and tests."""

    SECRET_KEY = os.environ.get("FLASK_SECRET_KEY")

    # Sessions: short idle lifetime, no sensitive data in the cookie.
    PERMANENT_SESSION_LIFETIME = timedelta(minutes=30)
    SESSION_REFRESH_EACH_REQUEST = True
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"
    SESSION_COOKIE_SECURE = _as_bool(os.environ.get("SESSION_COOKIE_SECURE"), False)

    # Database connection (MySQL Connector/Python).
    DB_HOST = os.environ.get("DB_HOST", "127.0.0.1")
    DB_PORT = int(os.environ.get("DB_PORT", "3306"))
    DB_NAME = os.environ.get("DB_NAME", "gmu_management_system")
    DB_USER = os.environ.get("DB_USER", "root")
    DB_PASSWORD = os.environ.get("DB_PASSWORD", "")
    DB_CONNECT_TIMEOUT = int(os.environ.get("DB_CONNECT_TIMEOUT", "5"))

    # Login hardening. The delay is disabled in tests for speed.
    LOGIN_FAILURE_DELAY_SECONDS = float(
        os.environ.get("LOGIN_FAILURE_DELAY_SECONDS", "0.4")
    )

    # Set to "1" only on a trusted local machine to expose the full Stage 2
    # interface preview through the authenticated /prototype/ route.
    ENABLE_PROTOTYPE = _as_bool(os.environ.get("ENABLE_PROTOTYPE"), True)

    # Template/static locations.
    TEMPLATE_DIR = str(TEMPLATE_DIR)
    STATIC_DIR = str(STATIC_DIR)
    FRONTEND_DIR = str(FRONTEND_DIR)

    MAX_CONTENT_LENGTH = 1 * 1024 * 1024


class TestConfig(Config):
    """Configuration used by the automated test suite."""

    TESTING = True
    LOGIN_FAILURE_DELAY_SECONDS = 0.0
    SESSION_COOKIE_SECURE = False
