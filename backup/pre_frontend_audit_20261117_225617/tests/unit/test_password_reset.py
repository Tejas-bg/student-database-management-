"""Unit checks for the operator password-reset transaction."""

from __future__ import annotations

from werkzeug.security import generate_password_hash

from scripts.reset_account_password import persist_password_change


class FakeConnection:
    def __init__(self):
        self.events = []

    def commit(self):
        self.events.append("commit")

    def rollback(self):
        self.events.append("rollback")


class FakeCursor:
    def __init__(self, *, stored_hash_override=None):
        self.connection = FakeConnection()
        self.events = self.connection.events
        self.password_hash = None
        self.stored_hash_override = stored_hash_override

    def execute(self, query, parameters):
        if query.startswith("UPDATE"):
            self.password_hash = parameters[0]
            self.events.append("update")
        else:
            self.events.append("select")

    def fetchone(self):
        self.events.append("fetch")
        if self.stored_hash_override is not None:
            return (self.stored_hash_override,)
        return (self.password_hash,)


def test_password_reset_commits_only_after_hash_verification():
    cursor = FakeCursor()

    assert persist_password_change(cursor, 12, "ValidTest#123")
    assert cursor.events == ["update", "select", "fetch", "commit"]


def test_password_reset_rolls_back_when_hash_verification_fails():
    cursor = FakeCursor(
        stored_hash_override=generate_password_hash("DifferentTest#456")
    )

    assert not persist_password_change(cursor, 12, "ValidTest#123")
    assert cursor.events == ["update", "select", "fetch", "rollback"]
