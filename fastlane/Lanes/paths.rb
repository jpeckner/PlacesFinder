
SHARED_ROOT = "Shared"
SHARED_PROJECT_PATH = SHARED_ROOT + "/Shared.xcodeproj"

COORDINODE_ROOT = "CoordiNode"
COORDINODE_PROJECT_PATH = COORDINODE_ROOT + "/CoordiNode.xcodeproj"

PLACESFINDER_ROOT = "PlacesFinder"
PLACESFINDER_WORKSPACE = "PlacesFinder.xcworkspace"
PLACESFINDER_PROJECT_PATH = PLACESFINDER_ROOT + "/PlacesFinder.xcodeproj"
PLACESFINDER_SOURCE_BASE = "PlacesFinder"
PLACESFINDER_INFOPLIST_PATH = PLACESFINDER_SOURCE_BASE + "/Info.plist"

BUILD_PATH = "fastlane/Build"
GYM_FOLDER_PATH = BUILD_PATH + "/gym"

def path_relative_to_root(subpath)
  return PLACESFINDER_ROOT + "/" + subpath
end
