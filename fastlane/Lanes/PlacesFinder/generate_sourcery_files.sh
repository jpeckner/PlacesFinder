#!/bin/bash

set -e

cd ../../..
OUTPUT_DIR=$(pwd)/PlacesFinder/PlacesFinder/Sourcery/Output
rm -rf "$OUTPUT_DIR"

AUTO_MOCKABLE_IMPORTS="
import Foundation
import CoordiNode
#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SharedTestComponents
import SwiftDux
import UIKit
"
mint run krzysztofzablocki/sourcery sourcery                \
  --sources PlacesFinder/PlacesFinder                       \
  --templates PlacesFinder/PlacesFinder/Sourcery/Templates  \
  --templates Shared/Shared/Sourcery/Templates              \
  --args imports="$AUTO_MOCKABLE_IMPORTS"                   \
  --output "$OUTPUT_DIR"
