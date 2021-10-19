#!/usr/bin/env bash

####################################################################
# This script splits a two-decimal version string, such as "4.1.9"
# allowing us to increment all three positions
####################################################################

APP_JSON_PATH="./app.json"
VERSION_NUM=$(< "$APP_JSON_PATH" python -c 'import json,sys;obj=json.load(sys.stdin);print obj["versionNumber"]')
SELECTED_VERSION_ITEM=""
NEW_VERSION_NUM=""
version_items=("major" "minor" "patch")

# Declare dynamic switch-case function
function switch_case() {
    local msg="$1"      # Save first argument in a variable
    shift               # Shift all arguments to the left (original $1 gets lost)
    local arr=("$@")    # Rebuild the array with rest of arguments

    echo "> Version convention: major.minor.patch ($msg)"
    echo "> Select the version type you want to bump [1-${#arr[@]}]:"
    PS3="Select number: "
    select SELECTED_ITEM in "${arr[@]}"; do
      for item in "${arr[@]}"; do
        if [[ $item == "$SELECTED_ITEM" ]]; then
          break 2
        fi
      done
    done

    SELECTED_VERSION_ITEM=$SELECTED_ITEM
}

# Select version number to bump
switch_case "$VERSION_NUM" "${version_items[@]}"

function increment_version_number() {
  # Split major.minor.patch values to variables
  local MAJOR_VERSION
  local MINOR_VERSION
  local PATCH_VERSION

  MAJOR_VERSION=$(echo "$VERSION_NUM" | awk -F "." '{print $1}')
  MINOR_VERSION=$(echo "$VERSION_NUM" | awk -F "." '{print $2}')
  PATCH_VERSION=$(echo "$VERSION_NUM" | awk -F "." '{print $3}')

  case $SELECTED_VERSION_ITEM in
      major)
          MAJOR_VERSION=$((MAJOR_VERSION + 1))
          MINOR_VERSION=0
          PATCH_VERSION=0
          ;;
      minor)
          MINOR_VERSION=$((MINOR_VERSION + 1))
          PATCH_VERSION=0
          ;;
      patch)
          PATCH_VERSION=$((PATCH_VERSION + 1))
          ;;
      *)
          echo "error"
          ;;
  esac

  NEW_VERSION_NUM=$(echo "$VERSION_NUM" | awk -F "." '{print '"$MAJOR_VERSION"' "." '"$MINOR_VERSION"' ".'"$PATCH_VERSION"'" }')
  echo "New version number: $NEW_VERSION_NUM"

  # Update version number in app.json
  perl -pi -e "s/\"versionNumber\": \"$VERSION_NUM\"/\"versionNumber\": \"$NEW_VERSION_NUM\"/g" "$APP_JSON_PATH"
}
