# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# Record the start time (in seconds since epoch)
__BASHRC_START_TIME__=$(date +%s)

# Current log level
export BASH_LOG_LEVEL=INFO


# don't put duplicate lines or lines starting with space in the history and erase any
# present duplicates
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# Make history shared across terminals (taken from https://unix.stackexchange.com/a/48116)
HISTSIZE=3000 # long history
HISTFILESIZE=$HISTSIZE
function bashrc_historySync() {
    builtin history -a     # Append the just entered line to the $HISTFILE
    HISTFILESIZE=$HISTSIZE # Truncate $HISTFILE to $HISTFILESIZE lines by removing oldest entries
    builtin history -c     # Clear the history of the running session
    builtin history -r     # Insert content of $HISTFILE into history of running session
}
# override builtin history() to assure that history is sync'd before it is displayed
function history() {
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
    xterm-color | *-256color) color_prompt=yes ;;
esac
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
esac

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Logging function
# First input: Log-level name at which to log (DEBUG, INFO, WARN, ERROR)
# Second input: Message to log
# Note: Uses Env. Var $BASH_LOG_LEVEL to determine the log level to log at 
#       (default: INFO)
function log_message() {
    local msg_log_level_name="$1"
    local msg="$2"

    # Define log levels
    declare -A log_level_name_to_level_map
    log_level_name_to_level_map=(["DEBUG"]=0 ["INFO"]=1 ["WARN"]=2 ["ERROR"]=3)

    # Determine the maximum length of log level names
    local log_level_name_length_max=0
    for level_name in "${!log_level_name_to_level_map[@]}"; do
        local level_name_length=${#level_name}
        if [ $level_name_length -gt $log_level_name_length_max ]; then
            log_level_name_length_max=$level_name_length
        fi
    done

    # Determine the script name based on the call stack
    local script_name
    script_name=$(basename "${BASH_SOURCE[2]}")

    # Get the current log level from the environment variable, if set
    local current_log_level_name="${BASH_LOG_LEVEL:-INFO}"

    # Only log the message if the log level is the same or higher
    local msg_log_level="${log_level_name_to_level_map[$msg_log_level_name]}"
    local current_log_level="${log_level_name_to_level_map[$current_log_level_name]}"
    if [ $msg_log_level -ge $current_log_level ]; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") $(printf "%-${log_level_name_length_max}s" "$msg_log_level_name"):${script_name}: ${msg}"
    fi
}
function log_debug() {
    log_message DEBUG "$1"
}
function log_info() {
    log_message INFO "$1"
}
function log_warn() {
    log_message WARN "$1"
}
function log_error() {
    log_message ERROR "$1"
}
# Log a done message with an optional duration since some predefined start time.
# Usage: log_done [start_time]
# First input (optional): Start time in seconds since epoch. If omitted, no duration will be logged.
function log_done() {
    msg="Done"

    local start_time="$1"
    if [ -n "$start_time" ]; then
        local end_time
        end_time=$(date +%s)
        local duration=$((end_time - start_time))
        msg="${msg} - took ${duration}s"
    fi

    log_message DEBUG "$msg"
}

# Alias & other function definitions.
# First input: File to source
# Second input: Suppress error message if true (default is false)
# Return: 1 if the file existed and it was sourced.
function source_if_exists() {
    local FILE="$1"
    local SUPPRESS_ERROR="${2:-false}"

    if [ -f "$FILE" ]; then
        source "$FILE"
        return 0
    else
        if [ "$SUPPRESS_ERROR" != "true" ]; then
            log_warn "Cannot source '$FILE': No such file exists"
        fi
        return 1
    fi
}

source_if_exists "$HOME/.bash_aliases"

# Disable visual flicker when pressing tab on an empty line in Git-Bash for Windows
# As given here: https://github.com/microsoft/terminal/issues/7200
log_info "Disabling visual bell"
set bell-style none

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile)
if ! shopt -oq posix; then
    log_debug "Sourcing user completions"
    source_if_exists /usr/share/bash-completion/bash_completion true ||
        source_if_exists /etc/bash_completion true ||
        source_if_exists "$HOME/.bash_completion"
fi


log_done __BASHRC_START_TIME__
unset __BASHRC_START_TIME__
