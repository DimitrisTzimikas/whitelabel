#!/usr/bin/env bash

###############################################
# test script is created to test other scripts
###############################################

source ./prompt.sh

if prompt "> Do you want to release beta branch?"; then
  echo "Release beta"
fi

if prompt "> Do you want to change app name?"; then
  echo "Change app name"
else
  echo "Don't change app name"
fi
