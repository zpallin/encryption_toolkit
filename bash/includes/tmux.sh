
cat << TMUXCONF > ~/.tmux.conf
#
# == Zeppelin's Tmux Config ==
# Please read the configuration before using.
#
# If you want to update this config, please alter the ~/.bash_includes/tmux.sh file
# instead of ~/.tmux.conf. With zpallin/toolkit your configuration will be overwritten
# every time your session loads.
#
# Useful tools: https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
#

# use C-a instead of C-b
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# use pwd as default path
#set-option default-path "$PWD"

# use bash colors for tmux
set-option -g default-command bash
new -n WindowName bash --login
set -g default-terminal "screen-256color"

# split panes using | and -
bind \ split-window -h -c '#{pane_current_path}'
bind - split-window -v -c '#{pane_current_path}'
bind c new-window -c '#{pane_current_path}'
unbind '"'
unbind %

# use r as a shortcut to reload tmux config
#bind r source-file ~/.tmux.conf

# fast pane switching with Alt
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# enable mouse control
#set -g mouse-select-window on
#set -g mouse-select-pane on
#set -g mouse-resize-pane on
set -g mouse on

# turn off auto naming of windows
#set-option -g allow-rename off

# aggressively resize Tmux to take up entire shell
set-window-option -g aggressive-resize

# special pasting
bind-key -t vi-copy 'v' begin-selection
bind-key -t vi-copy 'y' copy-selection
bind-key -t vi-copy 'r' rectangle-toggle

# plugins
run-shell ~/PublicRepos/tmux-yank/yank.tmux
set -g @yank_selection 'primary'
TMUXCONF
