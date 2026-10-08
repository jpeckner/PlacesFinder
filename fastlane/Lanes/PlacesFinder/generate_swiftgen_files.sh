#!/bin/bash

set -e

cd ../../..

OUTPUT_DIR=$(pwd)/PlacesFinder/SwiftGen/Output
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"
mint run SwiftGen/SwiftGen swiftgen config run --config swiftgen.yml
