#!/usr/bin/env bash

##################################################
# This script change app name for both iOS/Android
###################################################

function renameAppName() {
  local APP_JSON_PATH="./app.json";
  local DEFAULT_APP_NAME;
  local NEW_APP_NAME;
  # iOS variables
  local IOS_PREFIX;
  local IOS_PROJECT_FILE;
  local IOS_PLIST_FILE;
  # Android variables
  local ANDROID_SRC_PREFIX="android/app/src/main";
  local ANDROID_VALUES;

  DEFAULT_APP_NAME=$(< "$APP_JSON_PATH" python -c 'import json,sys;obj=json.load(sys.stdin);print obj["name"]')
  NEW_APP_NAME=$(< "$APP_JSON_PATH" python -c 'import json,sys;obj=json.load(sys.stdin);print obj["displayName"]')

  echo "$DEFAULT_APP_NAME"
  echo "$NEW_APP_NAME"

  ########## RENAME IOS ##########
  IOS_PREFIX="ios/$DEFAULT_APP_NAME"
  IOS_PROJECT_FILE="ios/$DEFAULT_APP_NAME.xcodeproj/project.pbxproj"
  IOS_PLIST_FILE="$IOS_PREFIX/Info.plist"

  echo "> Patching ios product name in $IOS_PROJECT_FILE"
  perl -pi -e "s/PRODUCT_NAME = .*;/PRODUCT_NAME = \"$NEW_APP_NAME\";/g" "$IOS_PROJECT_FILE"

  echo "> Patching ios plist file in $IOS_PLIST_FILE"
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $NEW_APP_NAME" "$IOS_PLIST_FILE"

  ########## RENAME ANDROID ##########
  ANDROID_VALUES="$ANDROID_SRC_PREFIX/res/values/strings.xml"

  echo "> Patching android app name in $ANDROID_VALUES"
  perl -pi -e "s/\<string name=\"app_name\"\>.*\<\/string\>/\<string name=\"app_name\"\>$NEW_APP_NAME\<\/string\>/g" $ANDROID_VALUES
}
