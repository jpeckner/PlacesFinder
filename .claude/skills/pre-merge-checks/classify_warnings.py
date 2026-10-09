#!/usr/bin/env python3
"""Sort the warnings in an xcodebuild or `swiftlint analyze` log by whether the branch caused them.

Usage: classify_warnings.py <log> [base-ref, default develop]

Groups:
  changed lines   - on a line the branch added or changed (relative to the merge base
                    with base-ref); these fail the check
  touched files   - in a file the branch changed, but on a line it didn't
  elsewhere       - everything else, i.e. already on base-ref

Run from the repo root. Exits 1 if any warning is on a changed line.
"""

import collections
import os
import re
import subprocess
import sys

WARNING = re.compile(r"^(/[^:]+\.swift):(\d+):(?:\d+:)? warning: (.*)$")
HUNK = re.compile(r"^@@ -\S+ \+(\d+)(?:,(\d+))? @@")


def changed_lines(base):
    """Map each file the branch changed to the set of line numbers it added or changed."""
    diff = subprocess.run(
        ["git", "diff", "-U0", f"{base}...HEAD", "--", "*.swift"],
        check=True, capture_output=True, text=True,
    ).stdout

    lines = collections.defaultdict(set)
    path = None
    for line in diff.splitlines():
        if line.startswith("+++ "):
            path = None if line == "+++ /dev/null" else line[len("+++ b/"):]
            if path:
                lines[path]
        elif path and (match := HUNK.match(line)):
            start, count = int(match.group(1)), int(match.group(2) or 1)
            lines[path].update(range(start, start + count))
    return lines


def main():
    if len(sys.argv) not in (2, 3):
        print(__doc__)
        return 2
    log_path = sys.argv[1]
    base = sys.argv[2] if len(sys.argv) == 3 else "develop"

    branch = changed_lines(base)
    root = os.getcwd() + "/"

    groups = {"changed lines": [], "touched files": [], "elsewhere": []}
    seen = set()
    with open(log_path, encoding="utf-8", errors="replace") as log:
        for raw in log:
            match = WARNING.match(raw.rstrip("\n"))
            if not match or raw in seen:
                continue
            seen.add(raw)
            path = match.group(1).removeprefix(root)
            line = int(match.group(2))
            entry = f"{path}:{line}: {match.group(3)}"
            if line in branch.get(path, ()):
                groups["changed lines"].append(entry)
            elif path in branch:
                groups["touched files"].append(entry)
            else:
                groups["elsewhere"].append(entry)

    for name, entries in groups.items():
        print(f"== Warnings on {name}: {len(entries)}")
        for entry in sorted(entries):
            print(entry)

    return 1 if groups["changed lines"] else 0


if __name__ == "__main__":
    sys.exit(main())
