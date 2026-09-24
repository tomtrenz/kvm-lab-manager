SHELL := /usr/bin/env bash
.DEFAULT_GOAL := validate

.PHONY: validate test fmt
validate:
	terraform -chdir=terraform fmt -check -recursive
	terraform -chdir=terraform validate
	ansible-lint ansible/playbooks ansible/roles
	yamllint -s .
	shellcheck scripts/kvm-lab-manager
	python3 -m json.tool schemas/checkpoint-manifest.schema.json >/dev/null
	python3 -m unittest discover -s tests -p 'test_*.py'

test:
	python3 -m unittest discover -s tests -p 'test_*.py'

fmt:
	terraform -chdir=terraform fmt -recursive
