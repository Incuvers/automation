# Source user env flags

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

.PHONY: flash
flash: ## flash compute module eMMC with ubuntu 20.04
	@./scripts/flash-emmc

.PHONY: clean
clean: ## clean build artifacts
	@rm -rv build
