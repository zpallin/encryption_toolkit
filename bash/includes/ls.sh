#!/bin/bash

# colorize ls
export CLICOLOR=1
#export LSCOLORS=ExFxCxDxBxegedabagacad
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

alias ls="ls --color=auto"
