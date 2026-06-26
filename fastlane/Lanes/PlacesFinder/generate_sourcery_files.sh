#!/bin/bash

set -e

cd ../../..

BUILD_DIR=$(xcodebuild -project PlacesFinder.xcodeproj -scheme PlacesFinder-Debug -showBuildSettings 2>/dev/null | grep "    BUILD_DIR = " | awk '{print $3}')
SOURCE_PACKAGES_DIR="$(dirname "$(dirname "$BUILD_DIR")")/SourcePackages"

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
  --templates "$SOURCE_PACKAGES_DIR/checkouts/Shared/SharedTestComponents/Sourcery/Templates/AutoMockable.stencil" \
  --args autoMockableImports="Combine",autoMockableImports="CoordiNode",autoMockableImports="Foundation",autoMockableImports="Shared",autoMockableImports="SharedTestComponents",autoMockableImports="SwiftDux",autoMockableImports="UIKit" \
  --output "$OUTPUT_DIR"
