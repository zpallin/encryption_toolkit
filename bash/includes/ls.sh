#!/bin/bash

# colorize ls
export CLICOLOR=1
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

if [ "$(uname)" == "Darwin" ]; then
	export LSCOLORS=ExFxCxDxBxegedabagacad
	alias ls="ls -G"
else
	alias ls="ls --color=auto"
fi
