# Source user env flags
include .env
export $(shell sed 's/=.*//' .env)

.PHONY: help	
help:
	@echo Usage:
	@echo "  make [target]"
	@echo
	@echo Targets:
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "  %-30s %s\n", $$1, $$NF \
		 }' $(MAKEFILE_LIST)

.PHONY: all
all : setup flash

.PHONY: setup
setup: ## install packages, init and sync submodules, fetch and extract Ubuntu 20.04 img for CM3+
	@./scripts/setup

.PHONY: key-auth
key-auth: ## authorize new ssh key for master node
	@./scripts/ssh-auth

.PHONY: flash
flash: ## flash compute module eMMC with ubuntu 20.04
	@./scripts/flash-emmc

.PHONY: clean
clean: ## clean build artifacts
	@rm -rv build

.PHONY: ssh-auth
ssh-auth: ## start node build
	@./scripts/ssh-auth

.PHONY: config-cd
config-cd: ## run github actions cd config playbook
	@./scripts/run.sh cd-config.yaml

.PHONY: destroy-cd
destroy-cd: ## run github actions cd teardown playbook
	@./scripts/run.sh cd-teardown.yaml