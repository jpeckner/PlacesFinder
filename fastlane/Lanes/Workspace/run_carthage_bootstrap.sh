#!/bin/bash

WORKSPACE_ROOT=$(pwd)/../../..

# Shared

cd "$WORKSPACE_ROOT/Shared/BuildScripts"
./run_carthage_bootstrap.sh

cd "$WORKSPACE_ROOT/PlacesFinder/BuildScripts"
./run_carthage_bootstrap.sh
