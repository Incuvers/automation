# Source user env flags
include .env
export $(shell sed 's/=.*//' .env)

.PHONY: node-build
node-build: ## build node environment
	@./scripts/node-build

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