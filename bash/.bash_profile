# Init bash

test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval "$('/C/Program Files/Anaconda3/Scripts/conda.exe' 'shell.bash' 'hook')"
# <<< conda initialize <<<

echo "INFO:.bash_profile: Done!"
