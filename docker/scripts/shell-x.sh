#!/bin/bash

# Note: If the service is stopped, the -r switch starts the service in the background with its default
#   command, then connects to it with the provided command (or bash); and on exit the service is stopped
#   If the service is already running, -r is ignored, the provided command is run on the existing instance,
#   and the service is NOT stopped on exit.

# Default Values and Colours
RED='\033[0;31m';
NC='\033[0m'; # No Color
run=false;
index=1;
sleep=2;
shell="bash";

# Print the usage message
usage() {
	echo "";
	case "$1" in
		1) printf "${RED}Error: Illegal option ${2}${NC}\n\n" ;;
		2) printf "${RED}Error: option $2 requires an argument${NC}\n\n" ;;
		3) printf "${RED}Error: Too many arguments.${NC}\n\n" ;;
		8) printf "${RED}Error: Project file missing.${NC}\nMake sure there is a 'docker-compose.yml' and a '.env' file in the context directory.\n\n" ;;
		9) printf "${RED}Error: No project name found.${NC}\nMake sure the '.env' file defines 'COMPOSE_PROJECT_NAME'.\n\n" ;;
		10) printf "${RED}Error: A service name is required.${NC}\n\n" ;;
	esac
	echo "Usage: $0";
	echo "       service_name [-h] [-i <integer>] [-r] [-D] [-s <integer>] [-x <string>]";
	echo "       [-u <string>] [-e <string>] [-c <string>] [-h <string>] [command]";
	echo "";
	echo "This script starts the service(s) from the docker-compose.yml file in the context of the script,";
	echo "   then connects to the container with a bsah shell.";
	echo "";
	echo "Options:"
	echo "   service_name       The name of the service as defined in the docker compose YAML file.";
	echo "   -h, --help         Help: Show this message.";
	echo "   -i, --index        Index: The index of the container if there are multiple instances of a service. [default: 1]";
	echo "   -r, --run          Run: Start the container in detached mode with the usual command before connecting. ";
	echo "   -s, --sleep        Sleep: The delay (in seconds) between starting the container and running the command (when -r is used). [default: 2]";
	echo "   -x, --context      Context: The working directory of this script.  It must contain a docker-compose.yml file. ";
	echo "   -u, --user         User: Run as specified username or uid.";
	echo "   -e, --entrypoint   Entrypoint: A script to run (from within the container) before running the supplied command / shell.";
	echo "                       - Note: The script must end with 'exec \"\$@\";' so that it can run the remaining commands when it finishes.";
	echo "   -c, --copy         Copy: Once the container is started, copy a file to/from it using docker cp.";
	echo "                       - Parameter Format: '/source/path/file.txt:%s/dest/path' (%s replaced with container id, ie. '626ebd338db9:')";
	echo "   -h, --shell        Shell: The name of the shell to use. [default: bash]";
	echo "   -D, --no-deps      Dependencies: Do not start up dependencies when starting the service. ";
	echo "   command            A command to run inside the container, using the provided shell.";
    echo "";
	if [[ -z "$1" ]]; then exit 0; else exit "$1"; fi
}

# If the first parameter contains the help switch, show usage
if [[ "$1" =~ ^-([^-].*h|h).*$ || "$1" == "--help" ]]; then usage; fi

# Get the service name first and exit if empty or invalid
service="$1"
if [[ -z "$service" || "$service" =~ ^-.*$ ]]; then usage 10; fi
shift;

# Utility for handling arguments value assignments
set_arg() {
	if [[ -z "$ARG_VAL" ]]; then usage 2 "--$OPTARG"; fi
	if [[ -z "$1" ]]; then printf -v "$OPTARG" "$ARG_VAL";
	else printf -v "$1" "$ARG_VAL"; fi
}

# Check for options
while getopts ":hDri:s:x:c:u:e:-:" OPT; do
	amt="$((OPTIND-1))"; # Determine how far we have to shift
	ARG_VAL="$OPTARG"; # Capture the arg val for the set_arg function
	case "$OPT" in
		h  ) usage ;; # Show the usage information and exit
		:  ) usage 2 "-$OPTARG" ;; # An arg value was not provided (exit)
		\? ) usage 1 "-$OPTARG" ;; # Illegal Option (exit)
		r  ) shift "$amt"; run=true ;;
		i  ) shift "$amt"; set_arg "index" ;;
		s  ) shift "$amt"; set_arg "sleep" ;;
		x  ) shift "$amt"; set_arg "context" ;;
		c  ) shift "$amt"; set_arg "paths" ;;
		u  ) shift "$amt"; set_arg "user" ;;
		e  ) shift "$amt"; set_arg "entrypoint" ;;
		h  ) shift "$amt"; set_arg "shell" ;;
		D  ) shift "$amt"; no_deps='--no-deps' ;;
		-  ) shift; ARG_VAL="$1"; case "$OPTARG" in
				run			) run=true ;;
				index		) shift; set_arg ;;
				sleep		) shift; set_arg ;;
				context		) shift; set_arg ;;
				copy		) shift; set_arg "paths" ;;
				user		) shift; set_arg ;;
				entrypoint	) shift; set_arg ;;
				shell		) shift; set_arg ;;
				no-deps		) no_deps='--no-deps' ;;
				help		) usage ;; # Show the usage information and exit
				*			) usage 1 "--$OPTARG" ;; # Illegal Option (exit)
			esac
	esac
	OPTIND="1"; # Always reset the index since each option shifts as it goes
done; if [[ '--' == "$1" ]]; then usage 1 "--"; fi; # Illegal Option (exit)

# Make sure there are no extra arguments
if [[ ! -z "$2" ]]; then usage 3; fi

# If a context was supplied, change to that directory
if [[ ! -z "$context" ]]; then cd "$context"; fi

# Make sure the project files are present in the current context
if [[ ! -f '.env' || ! -f 'docker-compose.yml' ]]; then usage 8; fi

# Source the .env file to get the project name
source .env;

# Make sure a project name is defined (sourced from the .env file)
if [[ -z "$COMPOSE_PROJECT_NAME" ]]; then usage 9; fi

# Check for a specified user and format the argument
if [[ ! -z "$user" ]]; then user="-u $user"; fi;

# Get the command, or use bash as a default
cmd="$1"
cmd_disp='bash';
if [[ ! -z "$cmd" ]]; then cmd_disp="bash -c '$cmd'"; fi

# Get the id of the docker container
get_id() { id=$(docker ps | grep "${service}_${index}" | awk '{ print $1 }'); }

# Copy a file/folder between the system and the container
run_cp() {
	if [[ ! -z "$paths" ]]; then
		get_id;
		IFS=':';
		read -ra ADDR <<< "$paths";
		printf -v src "${ADDR[0]}" "${id}:";
		printf -v dest "${ADDR[1]}" "${id}:";
		docker cp "$src" "$dest";
	fi
}

# Check if the service is running
get_id;
if [[ ! -z "$id" ]]; then
	echo "'$service' is already runnning, attaching and running command \"$cmd2\"";
	run_cp;
	if [[ -z "$cmd" ]]; then
		docker-compose exec $user --index="$index" "$service" $entrypoint "$shell";
	else
		docker-compose exec $user --index="$index" "$service" $entrypoint "$shell" -c "$cmd";
	fi
else
	if $run; then
		# Start the service in detached mode so the required service is running
		printf "'$service' is in a stopped state, starting in the background... ";
		docker-compose up --no-build -d "$service";
		echo "Starting Service...";
		# Wait for the service to start and run its usual command
		sleep "$sleep";
		run_cp;
		echo "Attaching and running command \"$cmd_disp\"";
		# Connect to the service with the provided command
		if [[ -z "$cmd" ]]; then
			docker-compose exec $no_deps $user --index="$index" "$service" $entrypoint "$shell";
		else
			docker-compose exec $no_deps $user --index="$index" "$service" $entrypoint "$shell" -c "$cmd";
		fi
	else
		echo "'$service' is in a stopped state, starting with \"$cmd_disp\"";
		run_cp;
		# Connect to the service with the provided command
		if [[ -z "$cmd" ]]; then
			docker-compose run $no_deps $user --service-ports "$service" $entrypoint "$shell";
		else
			docker-compose run $no_deps $user --service-ports "$service" $entrypoint "$shell" -c "$cmd";
		fi
	fi
	# Stop and remove the service so it is not running in the background
	docker-compose rm --stop --force -v "$service";
fi
