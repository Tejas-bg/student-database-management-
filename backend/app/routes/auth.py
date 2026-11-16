"""Authentication routes: common login, logout, and password reset."""

from __future__ import annotations

import time

from flask import (
    Blueprint,
    current_app,
    flash,
    redirect,
    render_template,
    request,
    session,
    url_for,
)

from app.auth.security import login_required, safe_redirect_target, start_session
from app.services.auth_service import (
    authenticate,
    reset_password_with_token,
    request_password_reset,
    verify_reset_token,
)
from app.validators.auth_validator import GENERIC_LOGIN_ERROR, validate_login

bp = Blueprint("auth", __name__)


def _render_login(*, errors: list[str] | None = None, identifier: str = "", status: int = 200):
    return (
        render_template(
            "login.html",
            errors=errors or [],
            identifier=identifier,
            next_target=safe_redirect_target(request.args.get("next")),
        ),
        status,
    )


@bp.route("/login", methods=["GET", "POST"])
def login():
    if session.get("user_id"):
        return redirect(url_for("dashboard.index"))

    if request.method == "GET":
        return _render_login()

    identifier = request.form.get("identifier", "")
    password = request.form.get("password", "")
    next_target = safe_redirect_target(request.form.get("next"))

    errors = validate_login(identifier, password)
    if errors:
        return _render_login(errors=errors, identifier=identifier.strip(), status=400)

    user = authenticate(identifier, password)
    if user is None:
        delay = current_app.config.get("LOGIN_FAILURE_DELAY_SECONDS", 0)
        if delay:
            time.sleep(delay)
        return _render_login(
            errors=[GENERIC_LOGIN_ERROR],
            identifier=identifier.strip(),
            status=401,
        )

    start_session(user)
    return redirect(next_target or url_for("dashboard.index"))


@bp.post("/logout")
@login_required
def logout():
    session.clear()
    return redirect(url_for("auth.login"))


@bp.route("/forgot-password", methods=["GET", "POST"])
def forgot_password():
    if session.get("user_id"):
        return redirect(url_for("dashboard.index"))

    if request.method == "GET":
        return render_template("forgot_password.html")

    email = request.form.get("email", "").strip()

    if not email:
        return render_template(
            "forgot_password.html",
            errors=["Please enter your email address."],
            email=email,
            status=400,
        )

    if "@" not in email:
        return render_template(
            "forgot_password.html",
            errors=["Please enter a valid email address."],
            email=email,
            status=400,
        )

    request_password_reset(email)

    # Always show success to avoid email enumeration
    flash(
        "If an account exists with that email address, a password reset link "
        "has been sent.",
        "success",
    )
    return redirect(url_for("auth.login"))


@bp.route("/reset-password/<token>", methods=["GET", "POST"])
def reset_password(token):
    if session.get("user_id"):
        return redirect(url_for("dashboard.index"))

    # Verify token before showing form
    user_info = verify_reset_token(token)
    if user_info is None:
        flash("Invalid or expired password reset link.", "error")
        return redirect(url_for("auth.login"))

    if request.method == "GET":
        return render_template("reset_password.html", token=token)

    password = request.form.get("password", "")
    confirm_password = request.form.get("confirm_password", "")

    if not password or not confirm_password:
        return render_template(
            "reset_password.html",
            token=token,
            errors=["Please enter and confirm your new password."],
            status=400,
        )

    if password != confirm_password:
        return render_template(
            "reset_password.html",
            token=token,
            errors=["Passwords do not match."],
            status=400,
        )

    if len(password) < 8:
        return render_template(
            "reset_password.html",
            token=token,
            errors=["Password must be at least 8 characters long."],
            status=400,
        )

    if not reset_password_with_token(token, password):
        flash("Invalid or expired password reset link.", "error")
        return redirect(url_for("auth.login"))

    flash(
        "Your password has been reset successfully. You can now sign in with "
        "your new password.",
        "success",
    )
    return redirect(url_for("auth.login"))
