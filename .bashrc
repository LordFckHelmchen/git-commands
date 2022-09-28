# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Make history shared across terminals (taken from https://unix.stackexchange.com/a/48116)
HISTSIZE=3000                    # long history
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoredups:erasedups  # no duplicate entries
shopt -s histappend               # when exiting shell, append to history, don't overwrite it
function bashrc_historySync () {
  builtin history -a      # Append the just entered line to the $HISTFILE
  HISTFILESIZE=$HISTSIZE  # Truncate $HISTFILE to $HISTFILESIZE lines by removing oldest entries
  builtin history -c      # Clear the history of the running session
  builtin history -r      # Insert content of $HISTFILE into history of running session
}
# override builtin history() to assure that history is synch'ed before it is displayed
function history () {
  bashrc_historySync
  builtin history "$@"
}
PROMPT_COMMAND=bashrc_historySync

# Make history searchable via up/down keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colored Google test output
export GTEST_COLOR='yes'

# Alias & other function definitions.
# First input: File to source
# Second input: Flag if issue a warning if the file was not found (default: true)
# Return: true if the file existed and it was sourced.
function source_if_exists () {
    if [ -f "$1" ]; then
        source "$1"
        true
    else
        local ISSUE_WARNING=${2:-true}
        if $ISSUE_WARNING; then
            echo "WARNING:.bashrc:source_if_exists: Cannot source '$1': No such file exists"
        fi
        false
    fi
}
source_if_exists $HOME/.bash_aliases

# Highlight git branches
source_if_exists $HOME/git-prompt.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    echo "INFO:.bashrc: Sourcing user completions"
    source_if_exists $HOME/.bash_completion false || 
    source_if_exists /usr/share/bash-completion/bash_completion false || 
    source_if_exists /etc/bash_completion false
fi

echo "INFO:.bashrc: Done!"
