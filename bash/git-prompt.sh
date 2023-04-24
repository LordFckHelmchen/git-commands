# Make a colorful git prompt.
# Adapted from
#   https://coderwall.com/p/pn8f0g/show-your-git-status-and-branch-in-color-at-the-command-prompt


# First define some colors. This will make it easier to work with the escape sequences later:
COLOR_RED="\033[01;31m"
COLOR_YELLOW="\033[01;33m"
COLOR_GREEN="\033[01;32m"
COLOR_GREEN_LIGHT="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE_LIGHT="\033[01;34m"
COLOR_RESET="\033[00m"


# Function for the color formatting:
function git_color {
  local git_status
  git_status="$(git status 2> /dev/null)"

  # For previous git versions, also check for "directory".
  if [[ ! ( $git_status =~ "working tree clean" ) ]]; then
    echo -e "$COLOR_RED"
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e "$COLOR_YELLOW"
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e "$COLOR_GREEN"
  else
    echo -e "$COLOR_OCHRE"
  fi
}


# Function for the git branch:
function git_branch {
  local git_status
  git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}


## Incorporate into the PS1 declaration (broken up for clarity):
PS1="${debian_chroot:+($debian_chroot)}\[$COLOR_GREEN_LIGHT\]\u"  # User:
PS1+="@\h\[$COLOR_RESET\]"                                        # @machine:
PS1+=":\[$COLOR_BLUE_LIGHT\]\w"                                   # Current directory
PS1+="\[\$(git_color)\]"                                          # colors git status
PS1+="\$(git_branch)"                                             # Current branch
PS1+="\[$COLOR_BLUE_LIGHT\]\$\[$COLOR_RESET\] "                   # '#' for root, else '$
export PS1
