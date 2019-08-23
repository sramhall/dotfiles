# -G colorizes, -F / after directories, -h human readable sizes
alias ls="ls -GFh"
alias ll="ls -lGFh"
alias la="ls -laGFh"
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
