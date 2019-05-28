export GOPATH="$HOME/.go"
export PATH="$HOME/.scripts:$GOPATH/bin:$PATH"
export EDITOR="vim"
export TERMINAL="urxvtc"

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
fi
