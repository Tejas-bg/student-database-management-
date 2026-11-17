"""Consistent, safe error pages for 400/401/403/404/405/500."""

from __future__ import annotations

from flask import Flask, jsonify, render_template, request

ERROR_COPY = {
    400: ("Bad request", "The request could not be understood. Reload the page and try again."),
    401: ("Sign-in required", "Sign in with your university account to continue."),
    403: ("Access denied", "Your account does not have permission to open this page."),
    404: ("Page not found", "The page you asked for does not exist or has moved."),
    405: ("Method not allowed", "That action is not available on this page."),
    500: ("Something went wrong", "An unexpected problem occurred. Try again in a moment."),
}


def _wants_json() -> bool:
    return request.path.startswith("/health") or request.accept_mimetypes.best == "application/json"


def register_error_handlers(app: Flask) -> None:
    def handler(error):
        code = getattr(error, "code", 500)
        if code not in ERROR_COPY:
            code = 500
        title, message = ERROR_COPY[code]

        # A 400 description is set by our own validation code (for example the
        # CSRF message), so it is safe to show. Other 4xx/5xx copy stays fixed.
        if code == 400:
            message = getattr(error, "description", None) or message

        # Never expose exception details, SQL, or file paths to the user.
        if code >= 500:
            app.logger.exception("Unhandled error on %s", request.path)

        if _wants_json():
            return jsonify(error=title, message=message), code

        return (
            render_template(
                "errors/error.html",
                code=code,
                title=title,
                message=message,
            ),
            code,
        )

    for code in ERROR_COPY:
        app.register_error_handler(code, handler)

    @app.errorhandler(Exception)
    def unhandled(error):  # pragma: no cover - exercised by the 500 path
        app.logger.exception("Unhandled exception on %s", request.path)
        if _wants_json():
            return jsonify(error="Something went wrong"), 500
        return (
            render_template(
                "errors/error.html",
                code=500,
                title=ERROR_COPY[500][0],
                message=ERROR_COPY[500][1],
            ),
            500,
        )
