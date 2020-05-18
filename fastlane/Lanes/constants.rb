
SHARED_RELEASE_SCHEME = "Shared-Release"

PLACESFINDER_APP_ID = "com.justinpeckner.PlacesFinder"
PLACESFINDER_RELEASE_SCHEME = "PlacesFinder-Release"
PLACESFINDER_PROFILE_NAME = "PlacesFinder-Distribution"

PLACE_LOOKUP_BASE_URL = "https://api.yelp.com"

RELEASE_BRANCH_PREFIX = "release/"
RELEASE_BRANCH_TEMPLATE = RELEASE_BRANCH_PREFIX + "%{version_num}"
VERSION_NUM_REGEX = /(\d+\.\d+\.\d+)/
BUILD_NUM_REGEX = /(\d+)/
TAG_REGEX = Regexp.new("#{VERSION_NUM_REGEX.source}/#{BUILD_NUM_REGEX.source}")

def build_version_tag(version, buildNumber)
  return version + "/" + (buildNumber.to_s)
end
