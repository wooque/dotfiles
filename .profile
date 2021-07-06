export EDITOR="nano"
export PAGER="less"
export LESS=-RF
export SYSTEMD_LESS="RF"
export GOPATH="$HOME/.go"
export PATH="$HOME/.asdf/shims:$GOPATH/bin:$PATH"
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_X11_EGL=1
#export MOZ_ENABLE_WAYLAND=1

[[ -f ~/.bashrc ]] && . ~/.bashrc
