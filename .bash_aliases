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

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9    ]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Show tree of current directory (folders only)
alias dirtree='ls -R . | grep ":$" | sed -e "s/:$//" -e "s/[^\/]*\//|  /g" -e "s/|  \([^|]\)/|–– \1/g"'

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
alias gitlist='git for-each-ref --sort=committerdate refs/remotes --format="%(color:yellow)%(committerdate:relative)%(color:reset)|%(HEAD) %(color:green)%(refname:short)%(color:reset)|%(authorname)|%(contents:subject)" | column -t -s"|" | cut -c 1-180'
# Show file tree, ignoring git files; taken from https://stackoverflow.com/a/61565622/5202331
alias gittree='git ls-tree --full-name --name-only -tr HEAD | sed -e "s/[^-][^\/]*\//   |/g" -e "s/|\([^ ]\)/|-- \1/"'


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
    if is_on_path $1 ; then
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
    if [[ -d "$1" ]] || [[ -f "$1" ]];  # Directory or file
    then
        remove_from_path "$1" "$2"
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
        true
    else
        echo "WARNING:.bash_aliases:prepend_to_path: Can't add '$1' to \$$PATHVARIABLE: Not a path or directory."
        false
    fi
}

# Poetry
prepend_to_path "$HOME/.poetry/bin"

echo "INFO:.bash_aliases: Done!"
