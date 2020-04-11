#!/bin/bash

set -e

cd ../../..

mint run yonaskolb/XcodeGen XcodeGen generate   \
  --spec PlacesFinder/project.yml               \
  --project PlacesFinder
