#!/bin/bash

WORKSPACE_ROOT=$(pwd)/../../..

# Shared

cd "$WORKSPACE_ROOT/Shared/BuildScripts"
./run_carthage_bootstrap.sh

# CoordiNode

cd "$WORKSPACE_ROOT/CoordiNode/BuildScripts"
./run_carthage_bootstrap.sh

# PlacesFinder

cd "$WORKSPACE_ROOT/PlacesFinder/BuildScripts"
./run_carthage_bootstrap.sh
