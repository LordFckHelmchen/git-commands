# Alias & function definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

###############################################################################
# Default aliases
###############################################################################

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    log_warn "'dircolors' not found - can't define colored aliases for 'ls' & the 'grep'-family."
fi

# Add human readable file sizes & sort by byte-order (LC_ALL=C; e.g. hidden things first)
# See https://stackoverflow.com/a/30027660/5202331
alias la='LC_ALL=C ls --almost-all --group-directories-first --human-readable'
alias l='la --classify -1'
alias ll='l -l'

alias envsrt='env | sort'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Show tree of current directory (folders only)
alias dirtree='ls --recursive . | grep ":$" | sed -e "s/:$//" -e "s/[^\/]*\//|  /g" -e "s/|  \([^|]\)/|–– \1/g"'

# Show path, one directory per line
alias lspath='echo $PATH | tr ":" "\n"'

# Search for all occurrences of a string in all files
alias findstr='grep --ignore-case --recursive --files-with-matches'

# Syntax-highlighted (and therefore cooler) cat
if [[ $(type -t pygmentize) ]]; then
    alias dog='pygmentize -g'
else
    log_warn "'pygmentize' not found - can't define alias 'dog'."
fi

alias now='date -u +"%Y-%m-%dT%H:%M:%S.%7N%:z"'
###############################################################################
# Alias for git
###############################################################################
# Git status
alias gits='git status'

# Git fetch, update, prune
alias gitup='git fetch --all --prune && git pull'

# Git diff ignoring all sorts of whitespace.
alias gitd='git diff --ignore-space-at-eol --ignore-space-change --ignore-all-space --ignore-blank-lines --minimal'

# Git branch listing author and date on remotes.
alias gitlist='git for-each-ref --sort=committerdate refs/remotes --format="%(color:yellow)%(committerdate:relative)%(color:reset)|%(HEAD) %(color:green)%(refname:short)%(color:reset)|%(authorname)|%(contents:subject)" | column --table --separator="|" | cut --characters=1-180'

# Show file tree, ignoring git files; taken from https://stackoverflow.com/a/61565622/5202331
alias gittree='git ls-tree --full-name --name-only -tr HEAD | sed --expression="s/[^-][^\/]*\// |/g" --expression="s/|\([^ ]\)/|-- \1/"'

# List last commits as oneliners
alias gitl='git log --oneline --max-count 10'

# Show branches where the remote has been deleted
alias gitsdb='git branch --verbose | grep gone'

# GH Copilot
if [[ $(type -t gh) ]]; then
    alias ghc='gh copilot'
    alias ghcs='ghc suggest'
    alias ghce='ghc explain'
else
    log_debug "'gh' not found - can't define aliases using 'ghc'."
fi

###############################################################################
# Functions to help us manage paths
###############################################################################
# Checks if a given entity is already on a path variable
# First input: Name of the entity to be checked against the path variable
# Second input: Name of the path variable to check (default: PATH)
# Return: true if the entity existed on the path variable
function is_on_path() {
    local PATHVARIABLE=${2:-PATH}
    [[ :${!PATHVARIABLE}: == *:"$1":* ]] # Returns true if it's on the path
}

# First input: Name of the entity to be removed from the path variable
# Second input: Name of the path variable to be modified (default: PATH)
# Return: true if the entity existed on the path variable & has been removed
function remove_from_path() {
    if is_on_path "$1"; then
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE}; do
            if [[ $DIR != "$1" ]]; then
                NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
            fi
        done
        export "$PATHVARIABLE"="$NEWPATH"
        true
    else
        false
    fi
}

# First input: Name of a directory or file to be added to the front of a path variable
#              If this is not a dir/file, nothing will be done!
# Second input: Name of the path variable to be modified (default: PATH)
# Return: true if the dir/file has been added
# Example: prepend_to_path "newpath" MANPATH
function prepend_to_path() {
    local PATHVARIABLE=${2:-PATH}
    if [[ -d $1 ]] || [[ -f $1 ]]; then # Directory or file
        remove_from_path "$1" "$PATHVARIABLE"
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
        true
    else
        if [[ -n $DEBUG_BASH_SCRIPTS && $DEBUG_BASH_SCRIPTS -eq 1 ]]; then
            log_warn "prepend_to_path can't add '$1' to \$$PATHVARIABLE: Not a path or directory."
        fi
        false
    fi
}

###############################################################################
# OS checks
###############################################################################

# Checks we are running on Linux
# Return: true if on Linux, false otherwise
function is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

# Checks we are running on Windows
# Return: true if on Windows, false otherwise
function is_windows() {
    [[ "$(uname)" == MINGW* ]]
}

if ! is_linux && ! is_windows; then
    log_error "Running on an unknown operating system."
fi

###############################################################################
# Local bin paths
###############################################################################
# Pyenv
if is_windows; then
    # WINDOWS: Use pyenv-win
    export PYENV_HOME="$HOME/.pyenv/pyenv-win"
    if [[ -d $PYENV_HOME ]]; then
        export PYENV_ROOT=$PYENV_HOME
        export PYENV=$PYENV_HOME
        prepend_to_path "$PYENV_HOME/bin"
        prepend_to_path "$PYENV_HOME/shims"
    else
        unset PYENV_HOME
    fi
elif is_linux; then
    # LINUX: Use native pyenv
    export PYENV_HOME="$HOME/.pyenv"
    if [[ -d $PYENV_HOME ]]; then
        prepend_to_path "$PYENV_HOME/bin"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    else
        unset PYENV_HOME
    fi
fi

# Poetry
if is_linux; then
    export POETRY_HOME="$HOME/.poetry"
    if [[ -d $POETRY_HOME ]]; then
        prepend_to_path "$POETRY_HOME/bin"
    else
        unset POETRY_HOME
    fi
fi

# Highlight git branches based on Starship config
if [[ $(type -t starship) ]]; then
    log_debug "Using Starship."
    eval "$(starship init bash)"  # Assume git bash for windows
    if is_linux; then
        export PYTHONIOENCODING=utf8
    fi
elif source_if_exists $XDG_CONFIG_HOME/bash/git-prompt.sh true || source_if_exists $HOME/.config/bash/git-prompt.sh true; then
    log_debug "Using git-prompt.sh for git branch highlighting."
fi

# LINUX: User-specific bin path
if is_linux; then
    prepend_to_path "$HOME/.local/bin"
fi

# ADR-tools
export ADR_HOME="$HOME/.adr-tools"
if [[ -d $ADR_HOME ]]; then
    prepend_to_path "$ADR_HOME/src"
else
    unset ADR_HOME
fi

###############################################################################
# Update functions
###############################################################################

# Update a git repo
# First input: Directory of the git repo to update
function updateGitRepo {
    local repo_dir=$1
    if [[ -d $repo_dir ]]; then
        printf "\n[GIT-PULL LATEST CHANGES FOR $(basename "$repo_dir")]\n"
        local current_dir
        current_dir=$(pwd)
        cd "$repo_dir" || return
        git fetch --all --prune && git pull
        cd "$current_dir" || return
    else
        log_warn "Directory '$repo_dir' not found - can't update."
    fi
}

function updateAll {
    if is_windows; then
        # winget-based upgrade on Windows
        printf "\n[WINGET UPGRADE --ALL]\n"
        winget upgrade --all
    elif is_linux; then
        # apt-based upgrade on Linux
        printf "\n[APT UPDATE]\n"
        sudo apt update -y
        echo '[APT UPGRADE]'
        sudo apt upgrade -y
        echo '[APT AUTOCLEAN]'
        sudo apt autoclean -y
        echo '[APT AUTOREMOVE]'
        sudo apt autoremove -y
    fi

    if [[ $(type -t pipx) ]]; then
        printf "\n[PIPX UPGRADE-ALL]\n"
        pipx upgrade-all
    fi

    if [[ $(type -t uv) ]]; then
        printf "\n[UVX UPGRADE-ALL]\n"
        uv tool upgrade --all
    fi

    if [[ $(type -t gh) ]]; then
        printf "\n[GITHUB CLI EXTENSION UPGRADE-ALL]\n"
        gh extension upgrade --all
    fi

    # Loop through repo directories and update them
    local repos=("$PYENV_HOME" "$ADR_HOME")
    for repo in "${repos[@]}"; do
        updateGitRepo "$repo"
    done
}

log_done
