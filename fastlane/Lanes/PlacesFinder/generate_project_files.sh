#!/bin/bash

set -e

buildConfig=$1
if [[ $buildConfig != "Debug" && $buildConfig != "Release" ]]; then
    echo "Invalid build config specified: $buildConfig"
    exit 1
fi

cd ../../..
TEMP_PROJECT_YML_PATH=PlacesFinder/project-temp.yml
projectYMLPath=PlacesFinder/project.yml

# If Release config, modify the project.yml file to add PlacesFinder source files to
# PlacesFinderTests using this workaround (no direct support for this in Xcodegen).
# Keeping the source files out of PlacesFinderTests target in the Debug config 
# significantly speeds up builds.
if [[ "Release" = "$buildConfig" ]]; then
    projectYML=$(cat "$projectYMLPath")
    tempProjectYMLFile=$(mktemp "$TEMP_PROJECT_YML_PATH")
    trap "rm -f $tempProjectYMLFile" 0 2 3 15
    echo -e "$projectYML" > "$tempProjectYMLFile"
    sed 's/^\([[:blank:]]*\).*placeholder:PlacesFinderTests:sources:path.*/\1- path: PlacesFinder/' $projectYMLPath > "$tempProjectYMLFile"
    projectYMLPath=$tempProjectYMLFile
fi

mint run yonaskolb/XcodeGen XcodeGen generate   \
  --spec "$projectYMLPath"                      \
  --project PlacesFinder
