export EDITOR="nano"
export PAGER="less"
export LESS=-RF
export SYSTEMD_LESS="RF"
export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin:$HOME/.asdf/shims:$GOPATH/bin:/usr/local/go/bin:$PATH"
export GTK_A11Y=none

. $HOME/.bashrc

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec sway > .sway.log 2>&1
fi
