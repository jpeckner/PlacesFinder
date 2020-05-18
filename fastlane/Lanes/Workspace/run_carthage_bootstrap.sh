#!/bin/bash

WORKSPACE_ROOT=$(pwd)/../../..

cd "$WORKSPACE_ROOT/PlacesFinder"
carthage bootstrap          \
  --platform iOS            \
  --cache-builds
