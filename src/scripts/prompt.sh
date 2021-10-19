#!/usr/bin/env bash

#######################################################################
# This script takes $1 as argument and displays the question to user
# then user needs to answer with y or n
#######################################################################

function prompt() {
  local QUESTION=$1

  while true; do
    read -r -p "$QUESTION [y/n]: " -n 1
    echo

    if [[ $REPLY == y ]]; then
      return 0
    elif [[ $REPLY == n ]]; then
      return 1
    else
      echo "> Please give answer of y or n."
    fi
  done
}
