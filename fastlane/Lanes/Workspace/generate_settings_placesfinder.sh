#!/bin/bash

### Constants ###

SETTINGS_BUILD_DIR=fastlane/Build/Settings
MINTFILE_PATH=Mintfile
OTHER_DEPENDENCIES_BUILD_PATH=$SETTINGS_BUILD_DIR/Other
OTHER_DEPENDENCIES_CONFIG_PATH=$OTHER_DEPENDENCIES_BUILD_PATH/license_plist.yml

SETTINGS_BUNDLE_DIR=PlacesFinder/PlacesFinder/Settings.bundle
ROOT_PLIST_PATH=$SETTINGS_BUNDLE_DIR/Root.plist
BUNDLE_LICENSE_DIR=$SETTINGS_BUNDLE_DIR/Licenses
BUNDLE_LICENSE_FILES_DIR=$BUNDLE_LICENSE_DIR/Plists
LICENSE_PLIST_PATH=$BUNDLE_LICENSE_DIR/LicensesList.plist

declare -a CARTHAGE_PROJECTS=("CoordiNode" "Shared" "PlacesFinder")

### Functions for generating plists in SETTINGS_BUILD_DIR ###

function verifyGeneratePlistsSuccess {
    generatedLicensesPath=$1
    expectedNumPlists=$2

    if [ ! -d $generatedLicensesPath ]; then
        echo "$generatedLicensesPath not found!"
        exit 1
    fi
    
    # Unfortunately, LicensePlist doesn't exit with a non-zero status even when something
    # goes wrong (such as downloading a license from Github), so we need to manually
    # verify that all expected plists were downloaded.
    numPlistFilesFound=$(find $generatedLicensesPath -name "*.plist" -print | wc -l | awk '{print $1}')
    if [ $expectedNumPlists != $numPlistFilesFound ]; then
        echo "An error occurred running LicensePlist; expected $expectedNumPlists files to be generated, but found $numPlistFilesFound"
        exit 1
    fi
}

function generatePlistsForCarthageProject {
    project=$1
    gitHubToken=$2
    expectedNumPlists=$3

    mint run mono0926/LicensePlist license-plist        \
        --cartfile-path $project/Cartfile               \
        --output-path $SETTINGS_BUILD_DIR/$project      \
        --prefix Licenses                               \
        --github-token $gitHubToken                     \
        --force                                         \
        --suppress-opening-directory
        
    generatedLicensesPath=$SETTINGS_BUILD_DIR/$project/Licenses
    verifyGeneratePlistsSuccess $generatedLicensesPath $expectedNumPlists
}

function generatePlistsForConfigFile {
    gitHubToken=$1
    expectedNumPlists=$2

    mint run mono0926/LicensePlist license-plist            \
        --config-path $OTHER_DEPENDENCIES_CONFIG_PATH       \
        --output-path $OTHER_DEPENDENCIES_BUILD_PATH        \
        --prefix Licenses                                   \
        --github-token $gitHubToken                         \
        --force                                             \
        --suppress-opening-directory

    generatedLicensesPath=$OTHER_DEPENDENCIES_BUILD_PATH/Licenses
    verifyGeneratePlistsSuccess $generatedLicensesPath $expectedNumPlists
}

function generateCarthageProjectPlists {
    gitHubToken=$1

    for project in "${CARTHAGE_PROJECTS[@]}"
    do
        cartfileResolvedPath=$project/Cartfile.resolved
        if [ ! -f $cartfileResolvedPath ]; then
            echo "$cartfileResolvedPath not found!"
            exit 1
        fi

        generatePlistsForCarthageProject $project $gitHubToken
    done
}

function generateOtherDependencyPlists {
    gitHubToken=$1

    if [ ! -f $MINTFILE_PATH ]; then
        echo "$MINTFILE_PATH not found!"
        exit 1
    fi

    mkdir $OTHER_DEPENDENCIES_BUILD_PATH
    echo "github:" > $OTHER_DEPENDENCIES_CONFIG_PATH

    expectedNumOtherDependencies=0
    while read -r line
    do 
        if [[ "$line" == \#* ]]; then
            continue
        fi
    
        (( expectedNumOtherDependencies += 1 ))
        OWNER=$(echo "$line" | sed -E 's/(.*)\/(.*)@(.*)/\1/')
        PROJECT=$(echo "$line" | sed -E 's/(.*)\/(.*)@(.*)/\2/')
        VERSION=$(echo "$line" | sed -E 's/(.*)\/(.*)@(.*)/\3/')
    
        OUTPUT_ENTRY="
          - owner: $OWNER
            name: $PROJECT
            version: $VERSION"
        echo "$OUTPUT_ENTRY" >> $OTHER_DEPENDENCIES_CONFIG_PATH
    done < $MINTFILE_PATH

    generatePlistsForConfigFile $gitHubToken $expectedNumOtherDependencies
}

### Functions for copying/using plists in app bundle ###

function copyPlistsIntoAppBundle {
    allSubDirectories=("${CARTHAGE_PROJECTS[@]}" "Other")

    for subDirectory in "${allSubDirectories[@]}"
    do
        cp -R $SETTINGS_BUILD_DIR/$subDirectory/Licenses/ $BUNDLE_LICENSE_FILES_DIR
    done
}

function generateLicensePlistFile {
    index=0
    sortedFilesList=$(find $BUNDLE_LICENSE_FILES_DIR -name '*.plist' -print | sort -f)

    /usr/libexec/PlistBuddy -c 'Add :PreferenceSpecifiers array' $LICENSE_PLIST_PATH
    while read -r line
    do
        dependencyName=$(basename $line | sed -E 's/(.*).plist/\1/')
        /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:File string Licenses/Plists/"$dependencyName $LICENSE_PLIST_PATH
        /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Title string "$dependencyName $LICENSE_PLIST_PATH
        /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Type string PSChildPaneSpecifier" $LICENSE_PLIST_PATH
    
        (( index += 1 ))
    done <<< "$sortedFilesList"
}

function generateRootPlistFile {
    version=$1

    /usr/libexec/PlistBuddy -c 'Add :PreferenceSpecifiers array' $ROOT_PLIST_PATH
    
    index=0
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:FooterText string 'Copyright © 2019 Justin Peckner. All rights reserved.'" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Type string PSGroupSpecifier" $ROOT_PLIST_PATH
    
    (( index += 1 ))
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:File string Licenses/LicensesList" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Title string Licenses" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Type string PSChildPaneSpecifier" $ROOT_PLIST_PATH
    
    (( index += 1 ))
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:File string Acknowledgements/AcknowledgementsList" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Title string Acknowledgements" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Type string PSChildPaneSpecifier" $ROOT_PLIST_PATH
    
    (( index += 1 ))
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:DefaultValue string $version" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Key string sbVersion" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Title string Version" $ROOT_PLIST_PATH
    /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:$index:Type string PSTitleValueSpecifier" $ROOT_PLIST_PATH
}

### Begin script ###

set -e

if [[ "Scripts" != "$(basename $(pwd))" ]]; then
    echo "Invalid path for running script"
    exit 1
fi

while getopts ":g:v:" opt; do
  case $opt in
    g) githubToken="$OPTARG" ;;
    v) version="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2  ;;
  esac
done

if [[ $githubToken == "" || $version == "" ]]; then
    echo "No Github token provided"
    exit 1
fi

cd ../..

rm -rf $SETTINGS_BUILD_DIR
mkdir -p $SETTINGS_BUILD_DIR
generateCarthageProjectPlists $githubToken
generateOtherDependencyPlists $githubToken

rm -rf $BUNDLE_LICENSE_DIR
mkdir $BUNDLE_LICENSE_DIR
mkdir $BUNDLE_LICENSE_FILES_DIR
copyPlistsIntoAppBundle
generateLicensePlistFile
generateRootPlistFile "$version"
