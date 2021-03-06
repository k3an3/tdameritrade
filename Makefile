tests: ## Clean and Make unit tests
	python3 -m pytest -v tests --cov=tdameritrade

test: lint ## run the tests for travis CI
	@ python3 -m pytest -v tests --cov=tdameritrade

testall: ## run the tests including those that hit the actual api
	@ python3 -m pytest -v tests --cov=tdameritrade

lint: ## run linter
	flake8 tdameritrade 

annotate: ## MyPy type annotation check
	mypy -s tdameritrade

annotate_l: ## MyPy type annotation check - count only
	mypy -s tdameritrade | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	make -C ./docs clean

docs:  ## make documentation
	make -C ./docs html
	open ./docs/_build/html/index.html

micro:  ## steps before dist, defaults to previous tag + one micro
	. scripts/deploy.sh MICRO

minor:  ## steps before dist, defaults to previous tag + one micro
	. scripts/deploy.sh MINOR

major:  ## steps before dist, defaults to previous tag + one micro
	. scripts/deploy.sh MAJOR

dist:  ## dist to pypi
	rm -rf dist build
	python3 setup.py sdist
	python3 setup.py bdist_wheel
	twine check dist/* && twine upload dist/*

install:  ## install to site-packages
	pip3 install .

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean test tests help annotate annotate_l docs dist
