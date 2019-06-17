
COORDINODE_RELEASE_SCHEME = "CoordiNode-Release"

SHARED_RELEASE_SCHEME = "Shared-Release"

PLACESFINDER_APP_ID = "com.justinpeckner.PlacesFinder"
PLACESFINDER_RELEASE_SCHEME = "PlacesFinder-Release"
PLACESFINDER_PROFILE_NAME = "PlacesFinder-Distribution"

APP_SKIN_URL="https://api.jsonbin.io/b/5ceb347df4df3819800e1315/latest"
PLACE_LOOKUP_BASE_URL="https://api.yelp.com"
TEST_PLACE_LOOKUP_BASE_URL="http://localhost:8080"

RELEASE_BRANCH_PREFIX = "release/"
RELEASE_BRANCH_TEMPLATE = RELEASE_BRANCH_PREFIX + "%{version_num}"
VERSION_NUM_REGEX = /(\d+\.\d+\.\d+)/
BUILD_NUM_REGEX = /(\d+)/
TAG_REGEX = Regexp.new("#{VERSION_NUM_REGEX.source}/#{BUILD_NUM_REGEX.source}")

def build_version_tag(version, buildNumber)
  return version + "/" + (buildNumber.to_s)
end
