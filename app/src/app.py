import os
import logging
from flask import Flask, jsonify
from werkzeug.exceptions import HTTPException

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def create_app():
    app = Flask(__name__)

    app.config['VERSION'] = os.getenv('APP_VERSION', '0.0.0')

    @app.route('/health', methods=['GET'])
    def health():
        return jsonify({
            'status': 'healthy'
        }), 200

    @app.route('/version', methods=['GET'])
    def version():
        return jsonify({
            'version': app.config['VERSION']
        }), 200

    @app.errorhandler(HTTPException)
    def handle_http_exception(e):
        return jsonify({
            'error': e.name,
            'message': e.description
        }), e.code

    @app.errorhandler(Exception)
    def handle_exception(e):
        logger.error(f"Unexpected error: {str(e)}", exc_info=True)
        return jsonify({
            'error': 'Internal Server Error',
            'message': 'An unexpected error occurred'
        }), 500

    return app


if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('PORT', 8080))
    debug = bool(os.getenv('DEBUG', False))
    app.run(host='0.0.0.0', port=port, debug=debug)
