#!/bin/bash

# Default Values and Colours
RED='\033[0;31m';
YELLOW='\033[1;33m';
GREEN='\033[0;32m';
CYAN='\033[0;36m';
NC='\033[0m'; # No Color
tests=();
failures=();
test_failed=false;

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
	echo "Usage: $0 [-h] -t <string> [-x <string>]";
	echo "";
	echo "This script runs unit tests for the project.";
	echo "";
	echo "Options:"
	echo "   -h, --help      Help: Show this message";
	echo "   -t, --test      Test: Specify a test command to run (Multiple -t can be defined)";
	echo "   -x, --context   Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
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
while getopts ":hx:t:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		x  ) shift "$amt"; set_arg "context" ;;
		t  ) shift "$amt"; tests+=("${ARG_VAL}") ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				test 	) shift; tests+=("${ARG_VAL}") ;;
				context	) shift; set_arg ;;
				help	) usage ;; # Show the usage information and exit
				*	    ) usage 1 "--$OPTARG" ;; # Illegal Option (exit)
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

printf "\n${CYAN}Running tests for project ${YELLOW}'${COMPOSE_PROJECT_NAME}'${NC}\n\n";

# Iterate over the tests and output the code on the first failure
for i in "${tests[@]}"; do
	bash -c "$i";
	code="$?";
	if [[ "$code" -ne 0 ]]; then
		failures+=("(Code: $code) ${i}");
		test_failed=true;
	fi
done

if $test_failed; then
	printf "\n${RED}####################\n${RED}# FAIL!\n${RED}####################${NC}\n";
	printf "\nThe following tests failed:\n";
	for f in "${failures[@]}"; do
		echo "  - ${f}";
	done
	echo "";
	# Cleanup: Stop and remove containers for any services in the compose file
	docker-compose rm --stop --force -v;
	exit 1;
fi

printf "\n${GREEN}####################\n${GREEN}# SUCCESS!\n${GREEN}####################${NC}\n";
printf "\nAll tests completed successfully\n\n";

# Cleanup: Stop and remove containers for any services in the compose file
docker-compose rm --stop --force -v;
