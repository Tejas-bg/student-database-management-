"""Serve the Stage 2 interface preview behind real authentication.

The preview keeps its original relative asset paths, so it is mounted at
``/prototype/``. Every request requires a session, and role folders are gated
on the server after the requested path has been checked for traversal.
"""

from __future__ import annotations

from pathlib import Path, PurePosixPath

from flask import Blueprint, abort, current_app, redirect, render_template, send_from_directory, session, url_for

from app.auth.security import login_required

bp = Blueprint("prototype", __name__, url_prefix="/prototype")

ROLE_FOLDERS = {"student", "faculty", "admin"}
ROOT_PAGES = {"index.html", "login.html"}


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

    # Check the URL path before send_from_directory() normalises it. Encoded
    # dot segments (for example %2e%2e) must never reach the filesystem or be
    # used to bypass the role-folder gate below.
    parts = PurePosixPath(filename).parts
    if not parts:
        abort(404)
    if any(part in {".", ".."} or "\\" in part or part.startswith(".") for part in parts):
        abort(404)
    if any(part == "templates" for part in parts):
        abort(404)

    if parts[0] == "dashboard":
        if len(parts) < 3 or parts[1] not in ROLE_FOLDERS:
            abort(404)
        if parts[1] != session.get("role"):
            abort(403)
    elif parts[0] != "static" and not (len(parts) == 1 and parts[0] in ROOT_PAGES):
        abort(404)

    frontend_dir = Path(current_app.config["FRONTEND_DIR"]).resolve()
    safe_filename = str(PurePosixPath(*parts))
    target = frontend_dir.joinpath(*parts).resolve()
    if frontend_dir not in target.parents or not target.is_file():
        abort(404)

    return send_from_directory(frontend_dir, safe_filename)
