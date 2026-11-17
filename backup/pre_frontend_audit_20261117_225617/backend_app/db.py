"""MySQL connection helpers.

Connections are opened per unit of work and always closed. Repositories receive
a cursor and never build SQL with user input.
"""

from __future__ import annotations

from contextlib import contextmanager
from typing import Iterator

import mysql.connector
from flask import current_app
from mysql.connector import MySQLConnection
from mysql.connector.cursor import MySQLCursor


def connect() -> MySQLConnection:
    """Open a new connection using the application configuration."""
    config = current_app.config
    return mysql.connector.connect(
        host=config["DB_HOST"],
        port=config["DB_PORT"],
        user=config["DB_USER"],
        password=config["DB_PASSWORD"],
        database=config["DB_NAME"],
        connection_timeout=config["DB_CONNECT_TIMEOUT"],
        charset="utf8mb4",
        collation="utf8mb4_0900_ai_ci",
        autocommit=False,
    )


@contextmanager
def get_connection() -> Iterator[MySQLConnection]:
    """Yield a connection and guarantee it is closed."""
    connection = connect()
    try:
        yield connection
    finally:
        connection.close()


@contextmanager
def get_cursor(
    *, dictionary: bool = True, commit: bool = False
) -> Iterator[MySQLCursor]:
    """Yield a cursor inside a transaction-aware connection.

    ``commit=True`` commits after the block; any exception rolls back.
    """
    with get_connection() as connection:
        cursor = connection.cursor(dictionary=dictionary)
        try:
            yield cursor
            if commit:
                connection.commit()
        except Exception:
            connection.rollback()
            raise
        finally:
            cursor.close()


def ping() -> dict[str, str]:
    """Return safe connection facts for the health endpoint."""
    with get_cursor() as cursor:
        cursor.execute("SELECT VERSION() AS version, DATABASE() AS database_name")
        row = cursor.fetchone()
    return {
        "version": str(row["version"]),
        "schema": str(row["database_name"]),
    }
