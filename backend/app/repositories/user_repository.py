"""Data access for accounts. Every statement is parameterized."""

from __future__ import annotations

from mysql.connector.cursor import MySQLCursor

from app.models.user import User

_FIND_USER_SQL = """
SELECT
    u.user_id,
    u.login_identifier,
    u.email,
    u.password_hash,
    u.account_status,
    u.is_active,
    u.must_change_password,
    r.role_code,
    r.role_name,
    COALESCE(
        CONCAT_WS(' ', s.first_name, s.last_name),
        CONCAT_WS(' ', f.first_name, f.last_name),
        u.login_identifier
    ) AS display_name,
    s.student_id,
    f.faculty_id
FROM users AS u
JOIN roles AS r ON r.role_id = u.role_id
LEFT JOIN students AS s ON s.user_id = u.user_id
LEFT JOIN faculty AS f ON f.user_id = u.user_id
WHERE u.login_identifier = %s
   OR s.usn = %s
   OR f.employee_id = %s
   OR s.aadhaar = %s
   OR f.aadhaar = %s
LIMIT 1
"""


def find_by_identifier(cursor: MySQLCursor, identifier: str) -> User | None:
    """Return the account matching an identifier, or ``None``.

    The identifier is tried against five fields:
    1. users.login_identifier (covers admin identifiers like admin@domain.com)
    2. students.usn (covers student USN numbers)
    3. faculty.employee_id (covers faculty employee IDs)
    4. students.aadhaar (covers student Aadhaar numbers)
    5. faculty.aadhaar (covers faculty Aadhaar numbers)

    Ambiguous matches (more than one distinct user matching any of the five
    fields) are rejected safely by returning ``None`` rather than
    authenticating the wrong account.
    """
    # Detect ambiguous matches: count distinct users matching any identifier field
    cursor.execute("""
        SELECT COUNT(DISTINCT u.user_id) AS match_count
        FROM users AS u
        JOIN roles AS r ON r.role_id = u.role_id
        LEFT JOIN students AS s ON s.user_id = u.user_id
        LEFT JOIN faculty AS f ON f.user_id = u.user_id
        WHERE u.login_identifier = %s
           OR s.usn = %s
           OR f.employee_id = %s
           OR s.aadhaar = %s
           OR f.aadhaar = %s
    """, (identifier, identifier, identifier, identifier, identifier))

    row = cursor.fetchone()
    match_count = row["match_count"] if row else 0

    if match_count == 0:
        return None

    if match_count > 1:
        # Ambiguous match: reject safely without authenticating the wrong account
        return None

    # Exactly one match - proceed with authentication lookup
    cursor.execute(_FIND_USER_SQL, (identifier, identifier, identifier, identifier, identifier))
    row = cursor.fetchone()
    if row is None:
        return None
    return User(
        user_id=int(row["user_id"]),
        login_identifier=row["login_identifier"],
        email=row["email"],
        password_hash=row["password_hash"],
        account_status=row["account_status"],
        is_active=bool(row["is_active"]),
        must_change_password=bool(row["must_change_password"]),
        role_code=row["role_code"],
        role_name=row["role_name"],
        display_name=row["display_name"],
        student_id=row["student_id"],
        faculty_id=row["faculty_id"],
    )


def record_successful_login(cursor: MySQLCursor, user_id: int) -> None:
    """Reset the failure counter and stamp the successful login time."""
    cursor.execute(
        """
        UPDATE users
        SET last_login_at = NOW(),
            failed_login_attempts = 0
        WHERE user_id = %s
        """,
        (user_id,),
    )


def record_failed_login(cursor: MySQLCursor, user_id: int) -> None:
    """Increment the failure counter without locking the account automatically."""
    cursor.execute(
        """
        UPDATE users
        SET failed_login_attempts = LEAST(failed_login_attempts + 1, 255)
        WHERE user_id = %s
        """,
        (user_id,),
    )


def create_password_reset_token(cursor: MySQLCursor, user_id: int, token_hash: str, expires_at) -> int:
    """Insert a password reset token for the given user. Returns the token row id."""
    cursor.execute(
        """
        INSERT INTO password_reset_tokens (user_id, token_hash, expires_at)
        VALUES (%s, %s, %s)
        """,
        (user_id, token_hash, expires_at),
    )
    return int(cursor.lastrowid)


def consume_password_reset_token(cursor: MySQLCursor, token_hash: str):
    """Consume (mark as used) a password reset token by hash. Returns the user_id
    if the token is valid and not yet used, otherwise None."""
    cursor.execute(
        """
        SELECT user_id, expires_at, used_at
        FROM password_reset_tokens
        WHERE token_hash = %s
        LIMIT 1
        """,
        (token_hash,),
    )
    row = cursor.fetchone()
    if row is None:
        return None
    if row["used_at"] is not None:
        return None  # already used
    from datetime import datetime, timezone
    expires_at = row["expires_at"]
    if expires_at.tzinfo is None:
        expires_at = expires_at.replace(tzinfo=timezone.utc)
    if expires_at < datetime.now(timezone.utc):
        return None  # expired
    cursor.execute(
        """
        UPDATE password_reset_tokens
        SET used_at = NOW()
        WHERE token_hash = %s AND used_at IS NULL
        """,
        (token_hash,),
    )
    return int(row["user_id"])


def hash_token(token: str) -> str:
    """Hash a reset token using SHA-256 for deterministic comparison."""
    import hashlib
    return hashlib.sha256(token.encode()).hexdigest()


def invalidate_password_reset_tokens(cursor: MySQLCursor, user_id: int) -> None:
    """Invalidate all unused password reset tokens for a user."""
    cursor.execute(
        """
        UPDATE password_reset_tokens
        SET used_at = NOW()
        WHERE user_id = %s AND used_at IS NULL
        """,
        (user_id,),
    )