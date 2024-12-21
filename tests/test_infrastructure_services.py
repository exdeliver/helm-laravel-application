import pytest
import yaml
from subprocess import run

@pytest.fixture
def values():
    with open('charts/infrastructure-services/values.yaml') as f:
        return yaml.safe_load(f)

def test_mariadb_enabled(values):
    assert values['mariadb']['enabled'] is True

def test_helm_template():
    result = run([
        'helm', 'template', 'test',
        './charts/infrastructure-services',
        '--debug'
    ], capture_output=True)
    assert result.returncode == 0