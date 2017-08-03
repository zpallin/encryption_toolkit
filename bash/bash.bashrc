# System-wide .bashrc file for interactive bash(1) shells.
# Created by zpallin/toolkit
#   https://github.com/zpallin/toolkit

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
# [ -z "$PS1" ] && return

if [ -z "$PS1" ]; then
  shopt -s expand_aliases
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

################################################################################
# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ]; 
then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

################################################################################
# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; 
then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

################################################################################
# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

################################################################################
# colors
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LIGHTGRAY="\[\033[0;37m\]"
DARKGRAY="\[\033[1;30m\]"
LIGHTBLUE="\[\033[1;34m\]"
LIGHTGREEN="\[\033[1;32m\]"
LIGHTCYAN="\[\033[1;36m\]"
LIGHTRED="\[\033[1;31m\]"
LIGHTPURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
NOCOLOR="\[\033[0m\]"

################################################################################
# import all includes

echo "LOADING bash_includes"
for file in ~/.bash_includes/*.sh
do
  if [[ $(basename $file) == *"README.md"* ]];
  then
    echo " - $(basename $file) exists, but will not be sourced"    
  else
    if [ -f "$file" ]; 
    then
      echo " - Loading \"$file\""
      source "$file"
    else
      echo " - Doesn't exist: \"$file\""
    fi
  fi
done

echo "ADDING ~/.bash_bin to environment"
BASH_BIN=~/.bash_bin
mkdir -p $BASH_BIN
PATH="$BASH_BIN:$PATH"

