.PHONY: setup run test test-setup lint clean

PYTHON ?= python3
PIP    ?= $(PYTHON) -m pip

setup:
	$(PIP) install -r requirements.txt

run:
	streamlit run app.py

test-setup:
	$(PYTHON) test_setup.py

test:
	$(PYTHON) -m pytest tests/

lint:
	$(PYTHON) -m pyflakes agents/ tools/ app.py orchestrator.py || true

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .pytest_cache -exec rm -rf {} +
	rm -rf data/cache
