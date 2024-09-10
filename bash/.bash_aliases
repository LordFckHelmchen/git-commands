# Alias & function definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.



###############################################################################
# Default aliases
###############################################################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls --all --classify -l'
alias la='ls --almost-all'
alias l='ls --classify -C'
alias envsrt='env | sort'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Show tree of current directory (folders only)
alias dirtree='ls --recursive . | grep ":$" | sed -e "s/:$//" -e "s/[^\/]*\//|  /g" -e "s/|  \([^|]\)/|–– \1/g"'

# Show path, one directory per line
alias lspath='echo $PATH | tr ":" "\n"'

# Search for all occurences of string in all files
alias findstr='grep --ignore-case --recursive --files-with-matches'

# Snytax-highlighted (and therefore cooler) cat
alias dog='pygmentize -g'

###############################################################################
# Alias for git
###############################################################################

# Git status
alias gits='git status'
# Git fetch, update, prune
alias gitup='git fetch --all --prune && git pull'
# -diff ignoring all sorts of whitespaces.
alias gitd='git diff --ignore-space-at-eol --ignore-space-change --ignore-all-space --ignore-blank-lines --minimal'
# -branch listing author and date on remotes.
alias gitlist='git for-each-ref --sort=committerdate refs/remotes --format="%(color:yellow)%(committerdate:relative)%(color:reset)|%(HEAD) %(color:green)%(refname:short)%(color:reset)|%(authorname)|%(contents:subject)" | column --table --separator="|" | cut --characters=1-180'
# Show file tree, ignoring git files; taken from https://stackoverflow.com/a/61565622/5202331
alias gittree='git ls-tree --full-name --name-only -tr HEAD | sed --expression="s/[^-][^\/]*\//   |/g" --expression="s/|\([^ ]\)/|-- \1/"'
# List last commits as oneliners
alias gitl='git log --oneline --max-count 10'
# Show branches where the remote has been deleted
alias gitsdb='git branch --verbose | grep gone'

###############################################################################
# Functions to help us manage paths
###############################################################################

# Checks if a given entity is already on a path variable
# First input: Name of the entity to be checked against the path variable
# Second input: Name of the path variable to check (default: PATH)
# Return: true if the entity existed on the path variable
function is_on_path () {
    local PATHVARIABLE=${2:-PATH}
    [[ :${!PATHVARIABLE}: == *:"$1":* ]]  # Returns true if it's on the path
}

# First input: Name of the entity to be removed from the path variable
# Second input: Name of the path variable to be modified (default: PATH)
# Return: true if the entity existed on the path variable & has been removed
function remove_from_path () {
    if is_on_path "$1" ; then
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
            if [ "$DIR" != "$1" ] ; then
                NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
            fi
        done
        export $PATHVARIABLE="$NEWPATH"
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
function prepend_to_path () {
    local PATHVARIABLE=${2:-PATH}
    if [[ -d "$1" ]] || [[ -f "$1" ]]; then  # Directory or file
        remove_from_path "$1" "$PATHVARIABLE"
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
        true
    else
        if [[ -n $DEBUG_BASH_SCRIPTS && $DEBUG_BASH_SCRIPTS -eq 1 ]]; then
            echo "WARNING:.bash_aliases:prepend_to_path: Can't add '$1' to \$$PATHVARIABLE: Not a path or directory."
        fi
        false
    fi
}


###############################################################################
# OS checks
###############################################################################

# Checks we are running on linux
# Return: true if on linux, false otherwise
is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

# Checks we are running on windows
# Return: true if on windows, false otherwise
is_windows() {
    [[ "$(uname)" == MINGW* ]]
}

if ! is_linux && ! is_windows; then
    echo "ERROR:.bash_aliases: Running on an unknown operating system"
fi

###############################################################################
# Local bin paths
###############################################################################

# Pyenv
if is_windows; then
    # WINDOWS: Use pyenv-win
    export PYENV_HOME="$HOME/.pyenv/pyenv-win"
    if [ -d "$PYENV_HOME" ]; then
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
    if [ -d "$PYENV_HOME" ]; then
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
    prepend_to_path "$POETRY_HOME/bin"
fi

# Starship
if is_windows; then
    prepend_to_path "$HOME/AppData/Local/starship"
fi

# LINUX: User-specific bin path
if is_linux; then
    prepend_to_path "$HOME/.local/bin"
fi

# ADR-tools
prepend_to_path "$HOME/.adr-tools/src"

###############################################################################
# Update functions
###############################################################################

if is_windows; then
    # WINDOWS: Upgrade all winget-installed packages
    function updateAll {
        winget upgrade --all
    }
elif is_linux; then
    # LINUX: Do all the update stuff (except for dist-upgrade).
    function updateAll {
        echo '[UPDATE]'; sudo apt update -y;
        echo '[UPGRADE]'; sudo apt upgrade -y;
        echo '[CLEAN]'; sudo apt autoclean -y;
        echo '[REMOVE]'; sudo apt autoremove -y;
    }
fi


echo "INFO:.bash_aliases: Done!"
