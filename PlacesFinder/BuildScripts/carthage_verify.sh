#!/bin/bash

# Source: https://github.com/Carthage/workflows/blob/master/carthage-verify
#
# This script verifies that the commitish values in the Cartfile.resolved are in
# sync with the commitish values in the Carthage/Build/*.version files.

no_skip_missing=0

while [ "$1" != "" ]; do
    case $1 in
        -m | --no_skip_missing )    
            shift
            no_skip_missing=1
            ;;
    esac
    shift
done


sed -E 's/(github|git|binary) \"([^\"]+)\" \"([^\"]+)\"/\2 \3/g' Cartfile.resolved | while read line
do
    read -a array <<< "$line"

    # Handles:
    # - ReactiveCocoa/ReactiveSwift > ReactiveSwift
    # - Auth0/JWTDecode.swift > JWTDecode.swift
    # - https://github.com/Carthage/Carthage.git > Carthage
    # - https://www.mapbox.com/ios-sdk/Mapbox-iOS-SDK.json > Mapbox-iOS-SDK
    dependency=`basename ${array[0]} | awk -F '.(git|json)' '{print $1}'`

    resolved_commitish=${array[1]}

    echo -e "Cartfile.resolved[$dependency] at $resolved_commitish"

    version_file="Carthage/Build/.$dependency.version"

    if [ ! -f "$version_file" ]
    then
        echo -e -n "No version file found for $dependency at $version_file, "

        if [ $no_skip_missing -eq 1 ]
        then
            echo "aborting."
            exit 2
        else
            echo "skipping."
            echo
            continue
        fi
    fi

    version_file_commitish=`grep -o '"commitish".*"' "$version_file" | awk -F'"' '{ print $4 }'`

    echo -e "$version_file at $version_file_commitish"

    if [ "$resolved_commitish" != "$version_file_commitish" ]
    then
        echo
        echo -e "$dependency commitish ($version_file_commitish) does not match resolved commitish ($resolved_commitish)"
        exit 1
    fi

    echo
done
