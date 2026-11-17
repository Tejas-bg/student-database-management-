"""Plain data structures shared across layers (no ORM)."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class User:
    """An authenticated account as stored in ``users`` plus its role."""

    user_id: int
    login_identifier: str
    email: str | None
    password_hash: str
    account_status: str
    is_active: bool
    must_change_password: bool
    role_code: str
    role_name: str
    display_name: str
    student_id: int | None = None
    faculty_id: int | None = None

    @property
    def is_login_allowed(self) -> bool:
        # A seeded account becomes usable once an operator has set a real
        # password. ``pending_reset`` is therefore treated as login-capable,
        # while inactive/locked accounts remain rejected.
        return self.is_active and self.account_status in {"active", "pending_reset"}
