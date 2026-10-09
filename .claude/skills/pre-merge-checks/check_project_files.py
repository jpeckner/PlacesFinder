#!/usr/bin/env python3
"""Compare the .swift files on disk with the ones PlacesFinder.xcodeproj references.

A file that exists on disk but isn't in the project compiles into nothing and is
invisible to Periphery, so a missed project entry after a rename goes unnoticed.
Matching is by file name, which works because file names are unique in this repo;
the script says so if that stops being true.

Run from the repo root. Exits 1 if anything doesn't match.
"""

import collections
import os
import re
import sys

PBXPROJ = "PlacesFinder.xcodeproj/project.pbxproj"
SOURCE_ROOTS = [
    "PlacesFinder",
    "PlacesFinderTests",
    "PlacesFinderIntegrationTests",
    "PlacesFinderUITests",
]


def main():
    with open(PBXPROJ, encoding="utf-8") as f:
        pbxproj = f.read()

    in_project = {
        os.path.basename(path)
        for path in re.findall(r'path = "?([^";]+\.swift)"?;', pbxproj)
    }

    on_disk = collections.defaultdict(list)
    for root in SOURCE_ROOTS:
        for directory, _, files in os.walk(root):
            for name in files:
                if name.endswith(".swift"):
                    on_disk[name].append(os.path.join(directory, name))

    missing_from_project = sorted(
        path
        for name, paths in on_disk.items()
        if name not in in_project
        for path in paths
    )
    missing_from_disk = sorted(in_project - set(on_disk))
    duplicates = {name: paths for name, paths in on_disk.items() if len(paths) > 1}

    for path in missing_from_project:
        print(f"On disk but not in the project: {path}")
    for name in missing_from_disk:
        print(f"In the project but not on disk: {name}")
    for name, paths in sorted(duplicates.items()):
        print(f"Duplicate file name, check by hand: {name} ({', '.join(sorted(paths))})")

    if missing_from_project or missing_from_disk:
        return 1

    print("Project and disk match.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
