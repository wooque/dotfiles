export EDITOR="nano"
export PAGER="less"
export LESS=-RF
export SYSTEMD_LESS="RF"
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
export MOZ_ENABLE_WAYLAND=1

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
[ -d $HOME/.local/bin ] && PATH="$HOME/.local/bin:$PATH"
