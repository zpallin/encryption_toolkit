# System-wide .bashrc file for interactive bash(1) shells.

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

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
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

# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

# COLORS
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

# Marks
export MARKPATH=$HOME/.marks
function jump {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
  rm -i "$MARKPATH/$1"
}
function marks {
  ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

# Profile
parse_branch() {
  FORMAT_STRING=""
  IS_GIT=`git rev-parse --is-inside-work-tree > /dev/null 2>&1; echo $?`
  IS_HGR=`hg summary > /dev/null 2>&1; echo $?`

  if [ "$IS_HGR" == "0" ]; then
    FORMAT_STRING="hg:$(hg branch 2> /dev/null)"
    FORMAT_STRING="($FORMAT_STRING)"
  elif [ "$IS_GIT" == "0" ]; then
    FORMAT_STRING="git:$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
    FORMAT_STRING="($FORMAT_STRING)"
  fi

  echo $FORMAT_STRING
}

# logic for the branch type
branch="\$(parse_branch)"
if [ -n "$branch" ]; then
    branch="$DARKGRAY$LIGHTGREEN$branch$DARKGRAY$NOCOLOR"
fi

export PS1="$GREEN\u$DARKGRAY@$WHITE\h:$LIGHTGRAY\W $branch$WHITE\$$LIGHTGRAY "

# Make bash check its window size after a process completes
shopt -s checkwinsize

# append history
shopt -s histappend

# larger history
HISTFILEZIE=1000000
HISTSIZE=1000000

# ignorespace and ignoredups
HISTCONTROL=ignoreboth

# histignore
HISTIGNORE='ls:bg:fg:history'

# time stamps
HISTTIMEFORMAT='%F %T'

# fit cmd history on one line
shopt -s cmdhist

# store history immediate
PROMPT_COMMAND='history -a'

# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
  local SEARCH=' '
  local REPLACE='%20'
  local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
  printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi


###########
# ALIASES #
##########################################################################################

alias j='jump'

get_cookbook() {
  COOKBOOK_DEST="/home/zpallin/Desktop/Repositories/OutwardRepos/outward_chef_workstation/cookbooks"
  CURRENT_DIR="$(pwd)"

  if [ -z "$1" ]; then
    echo "ERROR: You need to declare a cookbook name to clone"
    return 1
  fi

  if [ ! -z "$1" ] && [ ! -z "$2" ] && ([ $1 = "debug" ] || [ $2 = "debug" ]); then
    echo " - Executing from: $CURRENT_DIR"
    echo " - Cookbook destination: $COOKBOOK_DEST"
  fi

  cd "$COOKBOOK_DEST"
  git clone git@bitbucket.org:outwardinc/$1

  cd "$CURRENT_DIR"
  return 0
}
