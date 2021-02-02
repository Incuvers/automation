#!/bin/bash

# Default Values and Colours
RED='\033[0;31m';
GREEN='\033[0;32m';
NC='\033[0m'; # No Color
run=false;
index=1;
sleep=2;
required=("service" "volume");

# Print the usage message
usage() {
	echo "";
	case "$1" in
		1) printf "${RED}Error: Illegal option ${2}${NC}\n\n" ;;
		2) printf "${RED}Error: option $2 requires an argument${NC}\n\n" ;;
		3) printf "${RED}Error: Too many arguments.${NC}\n\n" ;;
		4) printf "${RED}Error: A value is required for '${2}'.${NC}\n\n" ;;
		8) printf "${RED}Error: Project file missing.${NC}\nMake sure there is a 'docker-compose.yml' and a '.env' file in the context directory.\n\n" ;;
		9) printf "${RED}Error: No project name found.${NC}\nMake sure the '.env' file defines 'COMPOSE_PROJECT_NAME'.\n\n" ;;
	esac
	echo "Usage: $0 service_name -v <string> [-h] [-m <string>] [-x <string>]";
	echo "";
	echo "This script starts removes and loads the contents of a postgres database service.";
	echo "";
	echo "Options:"
	echo "   service_name       The name of the service as defined in the docker compose YAML file.";
	echo "   -h, --help         Help: Show this message";
	echo "   -v, --volume       Volume: The name of the volume containing the postgres data.  If specified the volume will be removed before loading data. ";
	echo "   -m, --migrations   Migrations: A command or a script which runs the database migrations. ";
	echo "   -x, --context      Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
    echo "";
	if [[ -z "$1" ]]; then exit 0; else exit "$1"; fi
}

# If the first parameter contains the help switch, show usage
if [[ "$1" =~ ^-([^-].*h|h).*$ || "$1" == "--help" ]]; then usage; fi

# Get the service name first
if [[ ! "$service" =~ ^-.*$ ]]; then service="$1"; shift; fi

# Utility for handling arguments value assignments
set_arg() {
	if [[ -z "$ARG_VAL" ]]; then usage 2 "--$OPTARG"; fi;
	if [[ -z "$1" ]]; then printf -v "$OPTARG" "$ARG_VAL";
	else printf -v "$1" "$ARG_VAL"; fi;
}

# Check for options
while getopts ":hv:x:m:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		v  ) shift "$amt"; set_arg "volume" ;;
		x  ) shift "$amt"; set_arg "context" ;;
		m  ) shift "$amt"; set_arg "migrations" ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				volume		) shift; set_arg ;;
				context		) shift; set_arg ;;
				migrations	) shift; set_arg ;;
				help		) usage ;; # Show the usage information and exit
				*			) usage 1 "--$OPTARG" ;; # Illegal Option (exit)
			esac
	esac
	OPTIND="1"; # Always reset the index since each option shifts as it goes
done; if [[ '--' == "$1" ]]; then usage 1 "--"; fi; # Illegal Option (exit)

# Check for required arguments
for i in "${required[@]}"; do
	if [[ -z "${!i}" ]]; then usage 4 "$i"; fi
done

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

# Stop and remove any running Db container
docker-compose rm --stop --force -v "$service";

# Remove the persistent volume
printf "Removing volume: ";
docker volume rm "${COMPOSE_PROJECT_NAME}_$volume";

# Explicitely start the database so it will load the SQL data
docker-compose up --no-build -d pg-db;

# Wait for the data to be loaded
id=$(docker ps | grep "${COMPOSE_PROJECT_NAME}_${service}" | awk '{ print $1 }');
printf "Loading the data ... ";
code=$(docker wait "$id" 2>&1);
printf "${GREEN}done${NC} (Exit Code: $code)\n";

if [[ ! -z "$migrations" ]]; then
	echo "Running Database Migrations...";
	eval $migrations;
fi

# Stop and remove the Db container
docker-compose rm --stop --force -v "$service";
