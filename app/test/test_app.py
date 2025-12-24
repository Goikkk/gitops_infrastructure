import os
import pytest
from src.app import create_app


@pytest.fixture
def client():
    os.environ["APP_VERSION"] = "1.2.3"
    app = create_app()
    app.config["TESTING"] = True

    with app.test_client() as client:
        yield client


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "healthy"}


def test_version_endpoint(client):
    response = client.get("/version")
    assert response.status_code == 200
    assert response.get_json() == {"version": "1.2.3"}