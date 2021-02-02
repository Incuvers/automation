#!/bin/bash

# Default Values and Colours
RED='\033[0;31m';
ORANGE='\033[0;33m';
YELLOW='\033[1;33m';
GREEN='\033[0;32m';
CYAN='\033[0;36m';
NC='\033[0m'; # No Color
force=false;
network="dev";

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
	echo "Usage: $0 [-h] [-f] [-x <string>] [-n <string>] [-b <string>] [-a <string>]";
	echo "";
	echo "This script builds the images and allocates resources defined in a docker-compose.yml file.";
	echo "";
	echo "Options:"
	echo "   -h, --help      Help: Show this message";
	echo "   -f, --force     Force: Remove named volumes and build without caching of custom images.";
	echo "   -x, --context   Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
	echo "   -n, --network   Network: The name of a network to create which would be shared with other components of the project [default: dev].";
	echo "   -b, --pre       Pre-Build Steps: A command which is run (b)efore the build process starts.";
	echo "   -a, --post      Post-Build Steps: A command which is run (a)fter the build process finishes.";
	echo "";
	if [[ -z "$1" ]]; then exit 0; else exit "$1"; fi
}

# Utility for handling argument value assignments
set_arg() {
	if [[ -z "$ARG_VAL" ]]; then usage 2 "--$OPTARG"; fi;
	if [[ -z "$1" ]]; then printf -v "$OPTARG" "$ARG_VAL";
	else printf -v "$1" "$ARG_VAL"; fi;
}

# Check for options
while getopts ":hfx:n:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		f  ) shift "$amt"; force=true ;;
		x  ) shift "$amt"; set_arg "context" ;;
		n  ) shift "$amt"; set_arg "network" ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				force	) force=true ;;
				context	) shift; set_arg ;;
				pre		) shift; set_arg ;;
				post	) shift; set_arg ;;
				network	) shift; set_arg ;;
				Help	) usage ;; # Show the usage information and exit
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

# Make sure the dev (or provided) network exists
docker network create --driver bridge "${COMPOSE_PROJECT_NAME}_${network}";

# Stop and remove containers for any services in the compose file
docker-compose rm --stop --force -v;

# Check for, and run pre-build steps
if [[ ! -z "$pre" ]]; then
	printf "\n${CYAN}Running Pre-Build Steps...${NC}\n";
	eval $pre;
fi

printf "\n${CYAN}Building Project: ${YELLOW}${COMPOSE_PROJECT_NAME}${NC}\n";
if $force; then
	printf "${ORANGE}Not using cache!${NC}\n";
	docker-compose down --volumes;
	docker-compose build --pull --no-cache;
else
	docker-compose build --pull;
fi

# Check for, and run post-build steps
if [[ ! -z "$post" ]]; then
	printf "\n${CYAN}Running Post-Build Steps...${NC}\n";
	eval $post;
fi

# Stop and remove containers for any services in the compose file
docker-compose rm --stop --force -v;

# Remove any dangling images that may have been orphaned during the build
printf "Post Build Step: Removing dangling images ... ";
docker image prune --force;
