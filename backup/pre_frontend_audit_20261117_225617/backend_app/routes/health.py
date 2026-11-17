"""Health endpoint used to prove the database connection is live."""

from __future__ import annotations

from flask import Blueprint, current_app, jsonify

from app.db import ping

bp = Blueprint("health", __name__)


@bp.get("/health")
def health():
    try:
        facts = ping()
    except Exception:
        current_app.logger.exception("Database health check failed")
        return jsonify(status="unhealthy", database="unavailable"), 503

    return jsonify(status="ok", database="connected", **facts)
