#!/bin/bash

set -e

cd ../../..

OUTPUT_DIR=$(pwd)/PlacesFinder/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery            \
  --sources PlacesFinder                                \
  --templates PlacesFinder/Sourcery/Templates           \
  --templates ../Shared/Shared/Sourcery/Templates       \
  --output "$OUTPUT_DIR"

OUTPUT_DIR=$(pwd)/PlacesFinderTests/Components/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery                                                            \
  --sources PlacesFinder                                                                                \
  --templates ../Shared/SharedTestComponents/Sourcery/Templates/AutoMockable.stencil    \
  --args autoMockableImports="Combine",autoMockableImports="CoordiNode",autoMockableImports="Foundation",autoMockableImports="Shared",autoMockableImports="SharedTestComponents",autoMockableImports="SwiftDux",autoMockableImports="UIKit" \
  --output "$OUTPUT_DIR"
