# This Makefile provides a set of commands to manage the development environment
# for the ElectroCat project, including creating and deleting Conda environments,
# setting up the development environment, running tests, linting, type checking,
# formatting code, and building documentation.

.DEFAULT_GOAL := help
SRC_DIRS := src tests scripts notebooks
COMMITLINT_PACKAGES := @commitlint/cli @commitlint/config-conventional

# Load .dev.env if present
ifneq (,$(wildcard .dev.env))
	include .dev.env
	export
endif

CONDA_ENV ?= ecat
PYTHON_VERSION ?= 3.12.9
VENV_DIR ?= .venv
UV_CACHE_DIR ?= .uv_cache
PRE_COMMIT_HOME ?= .pre-commit_cache

.PHONY: help create-conda delete-conda setup-dev clean-dev print-env \
		test format lint typecheck check precommit docs-build docs-serve clean

help:  ## Show this help message
	@echo "Use \`make <target>\` for available actions:"
	@awk '/^[a-zA-Z_-]+:.*##/ { \
		sub(/:.*## /, " "); \
		printf "\033[36m%-20s\033[0m %s\n", $$1, substr($$0,index($$0,$$2)) \
	}' $(MAKEFILE_LIST)

create-conda: ## Create Conda env with Python and Node.js (dev)
	@echo "Creating Conda environment $(CONDA_ENV) with Python $(PYTHON_VERSION)..."
	conda create -n $(CONDA_ENV) python=$(PYTHON_VERSION) nodejs -y -c conda-forge

delete-conda: ## Delete Conda env
	@if [ "$$(basename $$CONDA_PREFIX)" = "$(CONDA_ENV)" ]; then \
		echo "Cannot delete the active Conda environment '$(CONDA_ENV)'."; \
		echo "Please deactivate it first by running: conda deactivate"; \
		exit 1; \
	fi
	@echo "Deleting Conda environment $(CONDA_ENV)..."
	conda remove -n $(CONDA_ENV) --all -y

setup-dev: ## Set up uv-based development environment
	@if [ -z "$$CONDA_PREFIX" ] || [ "$$(basename $$CONDA_PREFIX)" != "$(CONDA_ENV)" ]; then \
		echo "Conda environment '$(CONDA_ENV)' is not active."; \
		echo "Please activate it first using: conda activate $(CONDA_ENV)"; \
		exit 1; \
	fi
	@echo "🔧 Setting up development environment with uv..."
	uv venv --python=$(PYTHON_VERSION)
	uv pip install --editable .[dev,docs]
	npm install --save-dev @commitlint/{cli,config-conventional}
	echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
	uvx pre-commit install --hook-type commit-msg

clean-dev: ## Remove only the uv virtual environment
	@echo "Cleaning up virtual environment..."
	rm -rf $(VENV_DIR)

print-env: ## Print loaded environment variables
	@echo "CONDA_ENV      = $(CONDA_ENV)"
	@echo "PYTHON_VERSION = $(PYTHON_VERSION)"
	@echo "VENV_DIR       = $(VENV_DIR)"
	@echo "SRC_DIRS       = $(SRC_DIRS)"
	@echo "UV_CACHE_DIR   = $(UV_CACHE_DIR)"

test: ## Run tests using pytest
	@echo "Running tests with pytest..."
	uv run pytest tests/

lint: ## Lint code with Ruff
	@echo "Linting src/ tests files with Ruff..."
	uv run ruff check "$(SRC_DIRS)"

format: ## Format code with ruff
	@echo "Formatting src/ tests files with Ruff..."
	uv run ruff check "$(SRC_DIRS)" --fix  --unsafe-fixes
	uv run ruff format "$(SRC_DIRS)"

typecheck: ## Static type checks with mypy
	@echo "Running static type checks with mypy..."
	uv run mypy "$(SRC_DIRS)"

check: lint format typecheck ## Run lint, format and typecheck
	@echo "All checks passed."

precommit: ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks..."
	@uv run pre-commit run --all-files || { \
		echo "Some hooks made changes. Please stage them and commit again."; \
		exit 0; \
	}

docs-format: ## Format only docstrings and markdown
	@echo "Formatting docstrings and markdown..."
	uv run blacken-docs src/ docs/
	uv run docformatter --in-place --recursive --style=numpy src/

docs-build: ## Build documentation using MkDocs
	@echo "Building documentation..."
	uv run mkdocs build

docs-serve: ## Serve documentation locally
	@echo "Serving documentation at http://localhost:8000"
	uv run mkdocs serve -a 0.0.0.0:8000

clean: ## Remove temporary files
	@echo "Cleaning up temporary files..."
	rm -rf \
		.cache \
		.pytest_cache \
		.mypy_cache \
		.ruff_cache \
		.uv_cache \
		.pre-commit_cache \
		commitlint.config.js \
		node_modules \
		package.json \
		package-lock.json \
		.coverage \
		htmlcov \
		dist \
		build \
		site \
		*.egg-info \
		**/__pycache__
