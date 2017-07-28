#!/bin/bash

################################################################################
# visual editor for system
export VISUAL=vim
export EDITOR="$VISUAL"

git-new-branch() {
  NEW_BRANCH="$1"
  IS_REPO=$(git -C ./ rev-parse > /dev/null 2>&1; echo $?)

  if [ -z $NEW_BRANCH ];
  then
    echo "Creates a new branch and pushes it to your origin automatically"
  fi

  if [ "$IS_REPO" == "0" ];
  then
    git checkout -b $1
    git push origin $1 --set-upstream
  fi
}
