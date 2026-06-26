#!/bin/bash

set -e

cd ../../..
APPCONFIG_PATH=$(pwd)/PlacesFinder/Config/AppConfig.plist
baseURL=$PLACESFINDER_BASE_URL
apiKey=$PLACESFINDER_API_KEY

rm -rf "$APPCONFIG_PATH"

/usr/libexec/PlistBuddy -c "Add :placeLookup dict" "$APPCONFIG_PATH"
/usr/libexec/PlistBuddy -c "Add :placeLookup:baseURL dict" "$APPCONFIG_PATH"
/usr/libexec/PlistBuddy -c "Add :placeLookup:baseURL:relative string "$baseURL "$APPCONFIG_PATH"
/usr/libexec/PlistBuddy -c "Add :placeLookup:apiKey string "$apiKey "$APPCONFIG_PATH"
