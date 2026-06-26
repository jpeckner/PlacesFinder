#!/bin/bash

set -e

cd ../../..
BUILD_DIR=$(xcodebuild -project PlacesFinder.xcodeproj -scheme PlacesFinder-Debug -showBuildSettings 2>/dev/null | grep "    BUILD_DIR = " | awk '{print $3}')
SOURCE_PACKAGES_DIR="$(dirname "$(dirname "$BUILD_DIR")")/SourcePackages"
GENERATOR_PATH="$SOURCE_PACKAGES_DIR/checkouts/CoordiNode/CoordiNode/Resources/CoordiNodeGenerator"
COORDINODE_DIR="$(pwd)/PlacesFinder/CoordiNode"
MODULE_STRUCTURE_YML="$COORDINODE_DIR/ModuleStructure.yml"
OUTPUT_DIR="$COORDINODE_DIR/Output"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

"$GENERATOR_PATH"           \
  "$MODULE_STRUCTURE_YML"   \
  "$OUTPUT_DIR"
