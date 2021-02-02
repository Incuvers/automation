#!/bin/bash

# Default Values and Colours
RED='\033[0;31m';
GREEN='\033[0;32m';
NC='\033[0m'; # No Color

# Print the usage message
usage() {
	echo "";
	case "$1" in
		1) printf "${RED}Error: Illegal option ${2}${NC}\n\n" ;;
		2) printf "${RED}Error: option $2 requires an argument${NC}\n\n" ;;
		3) printf "${RED}Error: Too many arguments.${NC}\n\n" ;;
		8) printf "${RED}Error: Project file missing.${NC}\nMake sure there is a 'docker-compose.yml' and a '.env' file in the context directory.\n\n" ;;
		9) printf "${RED}Error: No project name found.${NC}\nMake sure the '.env' file defines 'COMPOSE_PROJECT_NAME'.\n\n" ;;
	esac
	echo "Usage: $0 [service_name] [-h] [-D] [-x <string>]";
	echo "";
	echo "This script starts the service(s) from the docker-compose.yml file in the context of the script.";
	echo "   Specity the service name to start an individual service.";
	echo "";
	echo "Options:"
	echo "   service_name    The name of the service as defined in the docker compose YAML file.";
	echo "   -h, --help      Help: Show this message";
	echo "   -x, --context   Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
	echo "   -D, --no-deps   Dependencies: Do not start up dependencies when starting the service. ";
    echo "";
	if [[ -z "$1" ]]; then exit 0; else exit "$1"; fi
}

# If the first parameter contains the help switch, show usage
if [[ "$1" =~ ^-([^-].*h|h).*$ || "$1" == "--help" ]]; then usage; fi

# Try to get the service name first
if [[ "$1" =~ ^[^-].*$ ]]; then
	service="$1";
	shift;
fi

# Utility for handling arguments value assignments
set_arg() {
	if [[ -z "$ARG_VAL" ]]; then usage 1 "--$OPTARG"; fi
	if [[ -z "$1" ]]; then printf -v "$OPTARG" "$ARG_VAL";
	else printf -v "$1" "$ARG_VAL"; fi
}

# Check for options
while getopts ":hDx:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		x  ) shift "$amt"; set_arg "context" ;;
		D  ) shift "$amt"; no_deps='--no-deps' ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				no-deps	) no_deps='--no-deps' ;;
				context	) shift; set_arg ;;
				help	) usage ;; # Show the usage information and exit
				*		) usage 1 "--$OPTARG" ;; # Illegal Option (exit)
			esac
	esac
	OPTIND="1"; # Always reset the index since each option shifts as it goes
done; if [[ '--' == "$1" ]]; then usage 1 "--"; fi; # Illegal Option (exit)

# Make sure there are no extra arguments
if [[ ! -z "$1" ]]; then usage 3; fi

# If a context was supplied, change to that directory
if [[ ! -z "$context" ]]; then cd "$context"; fi

# Make sure the project files are present in the current context
if [[ ! -f '.env' || ! -f 'docker-compose.yml' ]]; then usage 8; fi

# Source the .env file to get the project name
source .env;

# Make sure a project name is defined (sourced from the .env file)
if [[ -z "$COMPOSE_PROJECT_NAME" ]]; then usage 9; fi

# Check for a service name
if [[ -z "$service" ]]; then
	echo "Running project '$COMPOSE_PROJECT_NAME'";
	docker-compose up $no_deps --no-build;
	# Cleanup ... Stop and remove containers for any services in the compose file
	docker-compose rm --stop --force -v;
else
	echo "Running service '$service' in project '$COMPOSE_PROJECT_NAME'";
	docker-compose up $no_deps --no-build $service;
	# Cleanup ... Stop and remove containers for any services in the compose file
	docker-compose rm --stop --force -v $service;
fi
