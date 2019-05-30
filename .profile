export GOPATH="$HOME/.go"
export PATH="$HOME/.scripts:$GOPATH/bin:$PATH"
export EDITOR="vim"
export TERMINAL="urxvtc"

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
elif [[ $0 == "-bash" ]]; then
    . ~/.bashrc
fi
