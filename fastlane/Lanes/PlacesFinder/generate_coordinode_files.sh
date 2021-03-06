#!/bin/bash

set -e

cd ../../..
GENERATOR_PATH=$(pwd)/PlacesFinder/Carthage/Checkouts/CoordiNode/CoordiNode/Resources/CoordiNodeGenerator
COORDINODE_DIR=$(pwd)/PlacesFinder/PlacesFinder/CoordiNode
OUTPUT_DIR="$COORDINODE_DIR/Output"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

$GENERATOR_PATH                             \
  "$COORDINODE_DIR/ModuleStructure.yml"     \
  "$OUTPUT_DIR"
