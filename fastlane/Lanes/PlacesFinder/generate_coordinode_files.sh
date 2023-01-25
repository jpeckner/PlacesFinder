#!/bin/bash

set -e

cd ../../..
GENERATOR_PATH="$(pwd)/Pods/CoordiNode/CoordiNode/Resources/CoordiNodeGenerator"
COORDINODE_DIR="$(pwd)/PlacesFinder/CoordiNode"
MODULE_STRUCTURE_YML="$COORDINODE_DIR/ModuleStructure.yml"
OUTPUT_DIR="$COORDINODE_DIR/Output"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

"$GENERATOR_PATH"           \
  "$MODULE_STRUCTURE_YML"   \
  "$OUTPUT_DIR"
