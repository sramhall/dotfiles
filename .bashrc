# -G colorizes, -F / after directories, -h human readable sizes
alias ls="ls -GFh"
alias la="ls -aGFh"
alias ll="ls -lGFh"
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias ra="repo forall -p -v -c"
