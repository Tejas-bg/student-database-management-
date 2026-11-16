"""Serve the Stage 2 interface preview behind real authentication.

The preview keeps its original relative asset paths, so it is mounted at
``/prototype/``. Every request requires a session, and role folders are gated
on the server.
"""

from __future__ import annotations

from pathlib import Path

from flask import Blueprint, abort, current_app, redirect, render_template, send_from_directory, session, url_for

from app.auth.security import login_required

bp = Blueprint("prototype", __name__, url_prefix="/prototype")

ROLE_FOLDERS = {"student", "faculty", "admin"}


@bp.get("/")
@bp.get("/dashboard/")
@login_required
def home():
    role = session.get("role")
    if role not in ROLE_FOLDERS:
        abort(403)
    return redirect(url_for("prototype.files", filename=f"dashboard/{role}/index.html"))


@bp.get("/<path:filename>")
@login_required
def files(filename: str):
    if filename == "login.html":
        # The preview shell's Sign out link lands here. Show a POST confirmation
        # instead of changing state on a GET request.
        return render_template("prototype_sign_out.html")

    parts = Path(filename).parts
    if parts and parts[0] == "templates":
        abort(404)
    if len(parts) > 1 and parts[0] == "dashboard" and parts[1] in ROLE_FOLDERS:
        if parts[1] != session.get("role"):
            abort(403)

    frontend_dir = Path(current_app.config["FRONTEND_DIR"]).resolve()
    target = (frontend_dir / filename).resolve()
    if frontend_dir not in target.parents or not target.is_file():
        abort(404)

    return send_from_directory(frontend_dir, filename)
