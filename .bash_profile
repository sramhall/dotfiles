if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#              |--Green--|                    |-Reset -|
export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[m\]$ "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad


# Set editor
export EDITOR="/usr/local/bin/nvim"

# Tab completion for git
# $_ means the last argument in the previous command, so this line tests for a file's existence, then runs it
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
test -f ~/.git-completion.bash && . $_

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
