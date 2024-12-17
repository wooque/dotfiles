export EDITOR="nano"
export PAGER="less"
export LESS=-RF
export SYSTEMD_LESS="RF"
export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin:$GOPATH/bin:/usr/local/go/bin:$PATH"
export MOZ_ENABLE_WAYLAND=1

. $HOME/.bashrc

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec sway > .sway.log 2>&1
fi
