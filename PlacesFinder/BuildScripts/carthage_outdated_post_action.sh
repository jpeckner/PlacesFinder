#!/bin/bash

# Save tons of build-time by running `carthage outdated` in the background via post-build action.
# To use this:
#   - In your scheme in Xcode, go to Build -> Post-actions -> + New Run Script Action and paste
#     this in. IMPORTANT: next to "Provide build settings from", select your target.
#   - After the first time you run this action, add the generated OutdatedDependencies.swift 
#     file to your target, and optionally add it in Git. Note that any warnings generated
#     likely won't show up until the next time you build your target.
#
# See https://medium.com/@maxchuquimia/use-swift-in-your-run-script-phase-74bfa0cdb0d8
# for a nice intro to using Swift in a script phase!

set -e

OUTPUT_PATH="$SRCROOT/PlacesFinder/OutdatedDependencies.swift"
echo "" > "$OUTPUT_PATH"

cd "$SRCROOT"
WARNING_LINES="$(carthage outdated --xcode-warnings)"

swift_code() {

cat <<EOF
import Foundation

let warningPrefix = "warning: "
let warningLines = """
"$WARNING_LINES"
"""

let transformedLines: [String] =
    warningLines.replacingOccurrences(of: "\"", with: "")
    .components(separatedBy: "\n")
    .compactMap { line in
        guard line.hasPrefix(warningPrefix) else { return nil }
        let droppedPrefixString = line.replacingOccurrences(of: warningPrefix, with: "")
        return "#warning(\"\(droppedPrefixString)\")"
    }

if !transformedLines.isEmpty {
    let warningsFileBody = transformedLines.joined(separator: "\n")
    try! warningsFileBody.write(toFile: "$OUTPUT_PATH", atomically: true, encoding: .utf8)
}

EOF
}

# Run the Swift code in swift_code()
echo "$(swift_code)" \
  | DEVELOPER_DIR="$DEVELOPER_DIR" \
  xcrun --sdk macosx \
  "$TOOLCHAIN_DIR/usr/bin/"swift -
