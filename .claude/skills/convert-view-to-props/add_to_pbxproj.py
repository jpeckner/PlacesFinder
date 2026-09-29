#!/usr/bin/env python3
"""Add a new Swift file to PlacesFinder.xcodeproj/project.pbxproj.

The new file joins the same Sources build phases (i.e. targets) as an existing
file, and the same group as another existing file, in alphabetical order.

Usage (from the repo root):
    python3 .claude/skills/convert-view-to-props/add_to_pbxproj.py \
        PlacesFinder/Modules/Search/Views/PrimaryView/Components/XView.swift \
        --targets-like XViewController.swift \
        --group-like SearchCTAView.swift
"""

import argparse
import os
import re
import secrets
import sys

PBXPROJ = "PlacesFinder.xcodeproj/project.pbxproj"


def fail(message):
    sys.exit(f"error: {message}")


def file_ref_id(text, name):
    matches = re.findall(rf"\t\t([0-9A-F]{{24}}) /\* {re.escape(name)} \*/ = {{isa = PBXFileReference;", text)
    if len(matches) != 1:
        fail(f"expected exactly one PBXFileReference named {name}, found {len(matches)}")
    return matches[0]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("new_path", help="repo-relative path of the new .swift file (must already exist)")
    parser.add_argument("--targets-like", required=True, help="existing filename whose targets the new file joins")
    parser.add_argument("--group-like", required=True, help="existing filename in the group the new file joins")
    args = parser.parse_args()

    if not os.path.isfile(args.new_path):
        fail(f"{args.new_path} does not exist")
    name = os.path.basename(args.new_path)

    text = open(PBXPROJ).read()
    if f"/* {name} */" in text:
        fail(f"{name} is already in {PBXPROJ}")

    used_ids = set(re.findall(r"\b[0-9A-F]{24}\b", text))

    def new_id():
        while True:
            candidate = secrets.token_hex(12).upper()
            if candidate not in used_ids:
                used_ids.add(candidate)
                return candidate

    # File reference, inserted just before the targets-like file's reference
    targets_ref = file_ref_id(text, args.targets_like)
    new_ref = new_id()
    anchor = f"\t\t{targets_ref} /* {args.targets_like} */ = {{isa = PBXFileReference;"
    ref_line = (f"\t\t{new_ref} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; "
                f"path = {name}; sourceTree = \"<group>\"; }};\n")
    index = text.index(anchor)
    text = text[:index] + ref_line + text[index:]

    # One build file per Sources phase that contains the targets-like file
    build_ids = re.findall(
        rf"\t\t([0-9A-F]{{24}}) /\* {re.escape(args.targets_like)} in Sources \*/ = {{isa = PBXBuildFile; "
        rf"fileRef = {targets_ref} ",
        text,
    )
    if not build_ids:
        fail(f"{args.targets_like} isn't in any Sources build phase")
    for old_build_id in build_ids:
        new_build_id = new_id()
        decl = f"\t\t{old_build_id} /* {args.targets_like} in Sources */ = {{isa = PBXBuildFile;"
        index = text.index(decl)
        text = (text[:index]
                + f"\t\t{new_build_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {new_ref} /* {name} */; }};\n"
                + text[index:])
        phase_entry = f"\t\t\t\t{old_build_id} /* {args.targets_like} in Sources */,\n"
        if text.count(phase_entry) != 1:
            fail(f"expected {old_build_id} in exactly one Sources phase")
        text = text.replace(phase_entry, phase_entry + f"\t\t\t\t{new_build_id} /* {name} in Sources */,\n")

    # Group child, in alphabetical order among the group-like file's siblings
    group_ref = file_ref_id(text, args.group_like)
    group_match = None
    for match in re.finditer(r"\t\t[0-9A-F]{24} /\* [^*]+ \*/ = \{\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = \(\n(.*?)\t\t\t\);\n(.*?)\t\t\};\n",
                             text, re.S):
        if f"\t\t\t\t{group_ref} /* {args.group_like} */,\n" in match.group(1):
            group_match = match
            break
    if group_match is None:
        fail(f"couldn't find the group containing {args.group_like}")
    folder = os.path.basename(os.path.dirname(args.new_path))
    if f"path = {folder};" not in group_match.group(2) and f"path = \"{folder}\";" not in group_match.group(2):
        fail(f"the group containing {args.group_like} doesn't have path {folder}")

    children = group_match.group(1).splitlines(keepends=True)
    new_child = f"\t\t\t\t{new_ref} /* {name} */,\n"
    child_name = lambda line: re.search(r"/\* (.+) \*/", line).group(1)
    position = next((i for i, line in enumerate(children) if child_name(line).lower() > name.lower()), len(children))
    children.insert(position, new_child)
    start, end = group_match.span(1)
    text = text[:start] + "".join(children) + text[end:]

    open(PBXPROJ, "w").write(text)
    print(f"added {name}: file ref {new_ref}, {len(build_ids)} build file(s), group of {args.group_like}")


if __name__ == "__main__":
    main()
