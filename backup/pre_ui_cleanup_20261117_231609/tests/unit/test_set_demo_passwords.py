"""Isolated checks for the local demo-account bulk password utility."""

from __future__ import annotations

import pytest
from werkzeug.security import generate_password_hash

from scripts.set_demo_passwords import (
    fetch_account_ids,
    set_demo_passwords,
    update_accounts,
    validate_password,
    verify_account_hashes,
)

PASSWORD = "ExampleStrong#2026"


class FakeCursor:
    def __init__(self, account_rows=None, hash_rows=None):
        self.account_rows = account_rows or {}
        self.hash_rows = hash_rows or {}
        self.events = []
        self.rowcount = 1

    def execute(self, query, params=None):
        self.events.append((query.strip(), params))
        if "SELECT u.user_id" in query:
            role = params[0]
            self._last_rows = [(uid,) for uid in self.account_rows.get(role, [])]
        elif "UPDATE users" in query:
            user_id = params[1]
            self.hash_rows[user_id] = params[0]
            self._last_rows = []
        elif "SELECT password_hash" in query:
            user_id = params[0]
            self._last_rows = [(self.hash_rows.get(user_id, ""),)]

    def fetchall(self):
        return list(getattr(self, "_last_rows", []))

    def fetchone(self):
        rows = getattr(self, "_last_rows", [])
        return rows[0] if rows else None


class FakeConnection:
    def __init__(self):
        self.events = []

    def start_transaction(self):
        self.events.append("start")

    def commit(self):
        self.events.append("commit")

    def rollback(self):
        self.events.append("rollback")


def test_password_policy_rejects_weak_passwords():
    for password in ("short", "alllowercase1!", "ALLUPPERCASE1!", "NoDigits!!"):
        with pytest.raises(ValueError):
            validate_password(password)


def test_fetch_account_ids_groups_roles():
    cursor = FakeCursor(account_rows={"admin": [1], "student": [2, 3], "faculty": [4]})
    ids = fetch_account_ids(cursor)
    assert ids == {"admin": [1], "student": [2, 3], "faculty": [4]}


def test_update_accounts_updates_each_id():
    cursor = FakeCursor()
    counts = update_accounts(cursor, {"admin": [1], "student": [2], "faculty": [3]}, "hash")
    assert counts == {"admin": 1, "student": 1, "faculty": 1}
    updates = [event for event in cursor.events if event[0].startswith("UPDATE")]
    assert len(updates) == 3


def test_verify_account_hashes_checks_all():
    password_hash = generate_password_hash(PASSWORD)
    cursor = FakeCursor(hash_rows={1: password_hash, 2: password_hash})
    assert verify_account_hashes(
        cursor,
        {"admin": [1], "student": [2], "faculty": []},
        PASSWORD,
    )


def test_bulk_reset_cancellation_does_not_start_a_transaction(monkeypatch):
    cursor = FakeCursor(account_rows={"admin": [1]})
    connection = FakeConnection()
    monkeypatch.setattr("builtins.input", lambda _: "NO")

    result = set_demo_passwords(
        connection,
        cursor,
        password=PASSWORD,
        confirm=True,
    )

    assert result is None
    assert connection.events == []


def test_bulk_reset_commits_after_verifying_all_hashes():
    cursor = FakeCursor(account_rows={"admin": [1], "student": [2]})
    connection = FakeConnection()

    result = set_demo_passwords(
        connection,
        cursor,
        password=PASSWORD,
        confirm=False,
    )

    assert result is not None
    assert connection.events == ["start", "commit"]
    assert result["counts"] == {"admin": 1, "student": 1, "faculty": 0}
