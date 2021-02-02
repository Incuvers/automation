
.PHONY: help
help: ## Print this help message and exit
	@echo Usage:
	@echo "  make [target]"
	@echo
	@echo Targets:
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "  %-30s %s\n", $$1, $$NF \
		 }' $(MAKEFILE_LIST)

.PHONY: bd
bd: ## Build all services
	@./scripts/build.sh --context ./ --pre ./pre-build.sh --post ./post-build.sh;

.PHONY: bd-f
bd-f: ## Build all services without cache
	@./scripts/build.sh --context ./ --pre ./pre-build.sh --post ./post-build.sh --force;


.PHONY: run
run: ## Starts up all services
	@./scripts/run-x.sh raspi --context ./;

.PHONY: snap18
snap18: ## Starts up all services
	@./scripts/run-x.sh snap18 --context ./;

.PHONY: snap20
snap20: ## Starts up all services
	@./scripts/run-x.sh snap20 --context ./;


.PHONY: snap-clean
snap-clean: ## Starts up the snap18 service and runs the 'snapcraft clean' command
	@./scripts/shell-x.sh snap18 --no-deps --context ./ 'snapcraft clean';


.PHONY: bash
bash: ## Starts up the raspi service with a bash shell
	@./scripts/shell-x.sh raspi --no-deps --context ./;

.PHONY: bash18
bash18: ## Starts up the snap18 service with a bash shell
	@./scripts/shell-x.sh snap18 --no-deps --context ./;

.PHONY: bash20
bash20: ## Starts up the snap20 service with a bash shell
	@./scripts/shell-x.sh snap20 --no-deps --context ./;


.PHONY: clean
clean: ## Removes all docker objects and volumes (for THIS project)
	@./scripts/cleanup.sh --context ./;

.PHONY: prune
prune: ## Removes all docker objects and volumes (FOR ALL PROJECTS)
	@docker system prune -a --volumes;
