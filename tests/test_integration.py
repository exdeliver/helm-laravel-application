# tests/test_integration.py
from kubernetes import client, config
import pytest
import time

@pytest.fixture
def k8s_client():
    config.load_kube_config()
    return client.CoreV1Api()

def test_mariadb_running(k8s_client):
    pods = k8s_client.list_namespaced_pod(
        namespace='infrastructure-staging',
        label_selector='app=mariadb'
    )
    assert len(pods.items) > 0
    assert pods.items[0].status.phase == 'Running'