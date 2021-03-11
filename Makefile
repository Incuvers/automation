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

.PHONY: ib-deploy
ib-deploy: ## run the build server config
	@./scripts/run.sh ib-deploy.yaml

.PHONY: ib-teardown
ib-teardown: ## run the build server teardown
	@./scripts/run.sh ib-teardown.yaml

.PHONY: is-deploy
is-deploy: ## run the iris staging client config
	@./scripts/run.sh ib-deploy.yaml

.PHONY: is-teardown
is-teardown: ## run the iris staging client teardown
	@./scripts/run.sh ib-teardown.yaml

.PHONY: id-deploy
id-deploy: ## run the iris deploy server config
	@./scripts/run.sh ib-deploy.yaml

.PHONY: id-teardown
id-teardown: ## run the iris deploy server teardown
	@./scripts/run.sh ib-teardown.yaml