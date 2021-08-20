#!/bin/bash

set -e

cd ../../..

OUTPUT_DIR=$(pwd)/PlacesFinder/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery                \
  --sources PlacesFinder                       \
  --templates PlacesFinder/Sourcery/Templates  \
  --templates Shared/Shared/Sourcery/Templates              \
  --output "$OUTPUT_DIR"

AUTO_MOCKABLE_IMPORTS="
import Foundation
import CoordiNode
import Shared
import SharedTestComponents
import SwiftDux
import UIKit
"
OUTPUT_DIR=$(pwd)/PlacesFinderTests/Components/Sourcery/Output
rm -rf "$OUTPUT_DIR"
mint run krzysztofzablocki/sourcery sourcery                                        \
  --sources PlacesFinder                                               \
  --templates Shared/SharedTestComponents/Sourcery/Templates/AutoMockable.stencil   \
  --args imports="$AUTO_MOCKABLE_IMPORTS"                                           \
  --output "$OUTPUT_DIR"
