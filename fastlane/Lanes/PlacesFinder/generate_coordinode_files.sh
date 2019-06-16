#!/bin/bash

set -e

cd ../../..
COORDINODE_DIR=$(pwd)/PlacesFinder/PlacesFinder/CoordiNode
OUTPUT_DIR="$COORDINODE_DIR/Output"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

cd CoordiNode/BuildScripts
chmod +x coordinode_generator.sh
./coordinode_generator.sh                   \
  "$COORDINODE_DIR/ModuleStructure.yml"     \
  "$OUTPUT_DIR"
