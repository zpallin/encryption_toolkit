#!/bin/bash

################################################################################
# Make bash check its window size after a process completes
shopt -s checkwinsize

# append history
shopt -s histappend

################################################################################
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


