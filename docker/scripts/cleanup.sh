#!/bin/bash

# Default Values and Colours
RED='\033[0;31m';
NC='\033[0m'; # No Color
yes=false;

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
	echo "Usage: $0 service_name [-h] [-y] [-x <string>]";
	echo "";
	echo "This script cleans up the resources allocated in a docker-compose.yml file.  ";
	echo "";
	echo "Options:"
	echo "   -h, --help      Help: Show this message";
	echo "   -y, --yes       Yes: Do not ask for confirmation";
	echo "   -x, --context   Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
	echo "";
	if [[ -z "$1" ]]; then exit 0; else exit "$1"; fi
}

# If the first parameter contains the help switch, show usage
if [[ "$1" =~ ^-([^-].*h|h).*$ || "$1" == "--help" ]]; then usage; fi

# Utility for handling arguments value assignments
set_arg() {
	if [[ -z "$ARG_VAL" ]]; then usage 2 "--$OPTARG"; fi
	if [[ -z "$1" ]]; then printf -v "$OPTARG" "$ARG_VAL";
	else printf -v "$1" "$ARG_VAL"; fi
}

# Check for options
while getopts ":hyx:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		y  ) shift "$amt"; yes=true ;;
		x  ) shift "$amt"; set_arg "context" ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				yes		) yes=true ;;
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

if ! $yes; then
	echo "WARNING! This will remove the following items for the '$COMPOSE_PROJECT_NAME' project:";
	echo "  - all images used by any service in the Compose file";
	echo "  - containers for services defined in the Compose file";
	echo "  - networks defined in the networks section of the Compose file";
	echo "  - the default network, if one is used";
	echo "  - named volumes declared in the 'volumes' section of the Compose file and anonymous volumes attached to containers.";
	echo "Note: Networks and volumes defined as external are not removed."
	echo "";
	read  -r -p "Are you sure you want to continue? [y/N] " answer;
fi

if $yes || [[ $answer =~ ^([yY][eE][sS]|[yY])$ ]]; then
	docker-compose down --rmi all --volumes;
fi