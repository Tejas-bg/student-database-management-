"""Application factory for the GM University Management System."""

from __future__ import annotations

from flask import Flask, session

from app.auth.security import csrf_token, validate_csrf
from app.errors import register_error_handlers
from config import Config


def create_app(test_config: dict | None = None) -> Flask:
    app = Flask(
        __name__,
        template_folder=Config.TEMPLATE_DIR,
        static_folder=Config.STATIC_DIR,
        static_url_path="/static",
    )
    app.config.from_object(Config)

    if test_config:
        app.config.update(test_config)

    if not app.config.get("SECRET_KEY"):
        raise RuntimeError(
            "FLASK_SECRET_KEY is not set. Copy .env.example to .env and add a "
            "long random secret before starting the application."
        )

    app.json.sort_keys = False

    # Server-side CSRF check for every state-changing request.
    app.before_request(validate_csrf)

    # Templates can call csrf_token() directly.
    app.jinja_env.globals["csrf_token"] = csrf_token

    from app.routes.auth import bp as auth_bp
    from app.routes.dashboard import bp as dashboard_bp
    from app.routes.health import bp as health_bp
    from app.routes.prototype import bp as prototype_bp
    from app.routes.students import bp as students_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(dashboard_bp)
    app.register_blueprint(health_bp)
    app.register_blueprint(prototype_bp)
    app.register_blueprint(students_bp)

    register_error_handlers(app)

    @app.after_request
    def security_headers(response):
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "DENY")
        response.headers.setdefault("Referrer-Policy", "same-origin")
        response.headers.setdefault(
            "Content-Security-Policy",
            "default-src 'self'; "
            "img-src 'self' data:; "
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; "
            "font-src 'self' https://fonts.gstatic.com; "
            "script-src 'self'; "
            "object-src 'none'; base-uri 'self'; frame-ancestors 'none'; "
            "form-action 'self'",
        )
        if app.config.get("SESSION_COOKIE_SECURE"):
            response.headers.setdefault(
                "Strict-Transport-Security", "max-age=31536000; includeSubDomains"
            )
        return response

    @app.context_processor
    def inject_globals():
        return {
            "session_user": {
                "user_id": session.get("user_id"),
                "role": session.get("role"),
                "role_name": session.get("role_name"),
                "display_name": session.get("display_name"),
            }
            if session.get("user_id")
            else None,
            "app_name": "GM University Management System",
        }

    return app
