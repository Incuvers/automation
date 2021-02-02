#!/bin/bash

# This script is intended to be executed from the context passed to the build script;
#   which is the directry containing the docker-compose.yml file

# Get dependency list files
echo "Pre Build Step: Gathering requirements lists";
python3 get_dependencies.py
cp ../requirements.txt ./_raspi/requirements.txt;
