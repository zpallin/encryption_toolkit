#!/bin/bash

################################################################################
# parse branch
#   supports git and hg... :|
parse_branch() {
  FORMAT_STRING=""
  IS_GIT=`git rev-parse --is-inside-work-tree > /dev/null 2>&1; echo $?`
  IS_HGR=`hg summary > /dev/null 2>&1; echo $?`

  if [ "$IS_HGR" == "0" ]; then
    FORMAT_STRING="hg:$(hg branch 2> /dev/null)"
  elif [ "$IS_GIT" == "0" ]; then
    FORMAT_STRING="git:$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  fi

  echo $FORMAT_STRING
}

# logic for the branch type
branch="\$(parse_branch)"
if [ -n "$branch" ] && [ "$branch" != "" ]; then
  branch=" $DARKGRAY($YELLOW$branch$DARKGRAY)$WHITE"
fi

# logic for attaching date
DATESTR=$(date)

export PS1="$WHITE:: $DARKGRAY($CYAN$DATESTR$DARKGRAY)$WHITE\n:: $GREEN\u$DARKGRAY@$WHITE\h:$LIGHTCYAN\W$branch\n:>$LIGHTGRAY "

