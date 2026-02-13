from flask import Blueprint

health_bp = Blueprint("health", __name__)


@health_bp.route("/health", methods=["GET"])
def health() -> str:
    """Health check endpoint.
    ---
    responses:
      200:
        description: Service is healthy
        examples:
          text/plain: RECIPE OK
    """
    return "NUTRITION OK"

