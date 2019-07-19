#!/bin/bash

################################################################################
# parse branch
#   supports git and hg... :|
parse-branch() {
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

get-fmt-branch() {
	B=$(parse-branch)
	if [ "$B" != "" ] && [ -n "$B" ]; then
		echo -e "$GRAY($YELLOW$B$GRAY)$NOCOLOR"
	else
		echo -e ""
	fi
}

# logic for the branch type

# logic for PS1 attributes
DBLCLN="\[$GRAY\]::\[$NOCOLOR\]"
FNLCLN="\[$GRAY\]:>\[$NOCOLOR\]"
DATEFMT="\[$GRAY\](\[$CYAN\]\$(date)\[$GRAY\])\[$NOCOLOR\]"
USERNAME="\[$LIGHTCYAN\]\u\[$GRAY\]@\[$GRAY\]\h\[$NOCOLOR\]"
DIRECTORY="\[$LIGHTRED\]\W\[$NOCOLOR\]"
BRANCH="\$(get-fmt-branch)"
export PS1="$DBLCLN $DATEFMT\n$DBLCLN $USERNAME:$DIRECTORY $BRANCH\n$FNLCLN "

