from flask import Flask



def create_app() -> Flask:
    app = Flask(__name__)

    # Import and register presentation layer routes
    from presentation.api.health import health_bp

    app.register_blueprint(health_bp)

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=8000, debug=False)
