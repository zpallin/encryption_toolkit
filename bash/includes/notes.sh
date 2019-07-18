#!/bin/bash

#
#	A simple bash command line utility for writing notes in localfiles
#
function note() {
	NOTEHOME=~/.notes
	REMOVE=false
	LIST=false
	TOUCH=false
	FILETYPE="markdown"
	POSITIONAL=()

	# Loop through and gather arguments
	while [[ $# -gt 0 ]]
	do
	key="$1"

	case $key in
		-rm|--remove)
		REMOVE=true
		shift # past argument
		;;
		-f|--filetype)
		FILETYPE=$2
		shift # past argument
		shift # past value
		;;
		-ls|--list)
		LIST=true
		shift # past argument
		;;
		-t|--touch)
		TOUCH=true
		shift # past argument
		;;
		*)    # unknown option
		POSITIONAL+=("$1") # save it in an array for later
		shift # past argument
		;;
	esac
	done

	NOTEPATH="${POSITIONAL[0]}"
	NOTEDIR=$(echo $NOTEPATH | sed 's/\(.*\)\/.*/\1/')
	NOTEFILE=$(echo $NOTEPATH | sed 's/.*\/\(.*\)/\1/')

	if ! [ -d $NOTEHOME ]; then
		mkdir $NOTEHOME
	fi

	if $LIST; then
		ls $NOTEHOME/$NOTEPATH
		return $?
	fi

	if $REMOVE; then
		rm -r $NOTEHOME/$NOTEPATH
		return $?
	fi

	if echo $NOTEPATH | grep -s \/; then
		NOTEDIR=$(echo $NOTEPATH | sed 's/\(.*\)\/.*/\1/')
		NOTEFILE=$(echo $NOTEPATH | sed 's/.*\/\(.*\)/\1/')

		mkdir -p $NOTEHOME/$NOTEDIR
	fi

	if $TOUCH; then
		if [ "$NOTEFILE" !=	 "" ]; then
			touch $NOTEHOME/$NOTEPATH
		fi
		return $?
	fi

	vim -c "set filetype=$FILETYPE" $NOTEHOME/$NOTEPATH
}
