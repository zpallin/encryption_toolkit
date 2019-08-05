#!/bin/bash

#
#	A simple bash command line utility for writing notes in localfiles
#
NOTEHOME=~/.notes

#
#	Help section for ~/.notes
#
read -r -d "" NOTEHELP <<EOF
${GREEN}Of Note${NOCOLOR}
  A simple cli note-taking tool for linux (that may also work on Mac).

${LIGHTBLUE}Usage${NOCOLOR}:
  note [\$FLAGS] \$NOTEPATH

${LIGHTBLUE}Flags${NOCOLOR}:
  ${LIGHTYELLOW}-h | --help${NOCOLOR}
    Shows you this menu.

  ${LIGHTYELLOW}-ls | --list${NOCOLOR}
    Shows a list of any files at the \$NOTEPATH.
    Don't include a \$NOTEPATH to get the top level.

  ${LIGHTYELLOW}-t | --touch${NOCOLOR}
    Creates an unwritten note at that location.

  ${LIGHTYELLOW}-f | --file-type${NOCOLOR}
    Use a specific filetype for reading.
    Default is "Markdown" or ".mdwn"

  ${LIGHTYELLOW}-rm | --remove${NOCOLOR}
    Remove the note indicated by the \$NOTEPATH.
EOF

function note-error() {
	echo -e "${RED}ERROR${NOCOLOR}: $1"
}

function note() {
	local HELP=false
	local REMOVE=false
	local LIST=false
	local TOUCH=false
	local FILETYPE="markdown"
	local POSITIONAL=()

	# Loop through and gather arguments
	while [[ $# -gt 0 ]]
	do
	key="$1"

	case $key in
		-h|--help)
		HELP=true
		shift
		;;
		-rm|--remove)
		REMOVE=true
		shift 
		;;
		-f|--filetype)
		FILETYPE=$2
		shift 
		shift 
		;;
		-ls|--list)
		LIST=true
		shift
		;;
		-t|--touch)
		TOUCH=true
		shift
		;;
		*)
		POSITIONAL+=("$1") # save it in an array for later
		shift 
		;;
	esac
	done

	if $HELP; then
		echo -e "$NOTEHELP"
		return 0
	fi

	local NOTEPATH="${POSITIONAL[0]}"
	local NOTEDIR=$(echo $NOTEPATH | sed 's/\(.*\)\/.*/\1/')
	local NOTEFILE=$(echo $NOTEPATH | sed 's/.*\/\(.*\)/\1/')

	if ! [ -d $NOTEHOME ]; then
		mkdir $NOTEHOME
	fi

	if $LIST; then
		ls $NOTEHOME/$NOTEPATH
		return $?
	fi

	if [[ "$NOTEPATH" == "" ]]; then
		if ! $HELP || ! $LIST; then
			note-error "Must specify a path for this command"
			echo -e "$NOTEHELP"
			return 1
		else
			echo -e "$NOTEHELP"
			return 0
		fi
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

function _note-dir-complete_() {
	local TMPFILE=/tmp/note-dir-complete.txt
	local cmd="${1##*/}"
	local word=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=($(compgen -W "$(ls $NOTEHOME)" -- "${word}"))
}

g_proj_dir=~/.notes/

_dev()
{
    local cmd=$1 cur=$2 pre=$3
    local _cur compreply

    _cur=$g_proj_dir/$cur
		compdirs=( $(compgen -d "$_cur" ) )
    compreply=( $( compgen -f "$_cur" ) )
		for d in ${compdirs[@]}; do
			compreply=($(echo ${compreply[@]} | sed "s#\($d\)\(\ *\$*\)#\1\/\2#"))
		done
    COMPREPLY=( ${compreply[@]#$g_proj_dir/} )
}

complete -F _dev -o nospace note
