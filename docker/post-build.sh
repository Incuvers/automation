#!/bin/bash

# This script is intended to be executed from the context passed to the build script;
#   which is the directry containing the docker-compose.yml file

# Cleanup dependency list files
echo "Post Build Step: Cleaning up requirements lists";
rm ./_raspi/dependencies-apt.conf
rm ./_raspi/requirements.txt
