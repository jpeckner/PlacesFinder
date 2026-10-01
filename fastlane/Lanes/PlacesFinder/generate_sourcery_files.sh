#!/bin/bash

set -e

cd ../../..

BUILD_DIR=$(xcodebuild -project PlacesFinder.xcodeproj -scheme PlacesFinder-Debug -showBuildSettings 2>/dev/null | grep "    BUILD_DIR = " | awk '{print $3}')
SOURCE_PACKAGES_DIR="$(dirname "$(dirname "$BUILD_DIR")")/SourcePackages"
AUTOMOCKABLE_TEMPLATE="$SOURCE_PACKAGES_DIR/checkouts/Shared/SharedTestComponents/Sourcery/Templates/AutoMockable.stencil"

# The AutoMockable template comes from the Shared package, so resolve packages if they haven't been fetched yet
if [ ! -f "$AUTOMOCKABLE_TEMPLATE" ]; then
  echo "AutoMockable template not found; resolving Swift package dependencies..."
  xcodebuild -resolvePackageDependencies -project PlacesFinder.xcodeproj -scheme PlacesFinder-Debug

  if [ ! -f "$AUTOMOCKABLE_TEMPLATE" ]; then
    echo "error: AutoMockable template still not found at $AUTOMOCKABLE_TEMPLATE" >&2
    exit 1
  fi
fi

OUTPUT_DIR=$(pwd)/PlacesFinder/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery            \
  --sources PlacesFinder                                \
  --templates PlacesFinder/Sourcery/Templates           \
  --output "$OUTPUT_DIR"

OUTPUT_DIR=$(pwd)/PlacesFinderTests/Components/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery                                                            \
  --sources PlacesFinder                                                                                \
  --templates "$AUTOMOCKABLE_TEMPLATE"                                                                  \
  --args autoMockableImports="Combine",autoMockableImports="CoordiNode",autoMockableImports="Foundation",autoMockableImports="Shared",autoMockableImports="SharedTestComponents",autoMockableImports="SwiftDux",autoMockableImports="UIKit" \
  --output "$OUTPUT_DIR"
