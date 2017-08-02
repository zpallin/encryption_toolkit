#!/bin/bash

################################################################################
# visual editor for system
export VISUAL=vim
export EDITOR="$VISUAL"

if type "git" > /dev/null 2>&1
then
  git config --global push.default "matching"
fi

