export EDITOR="nano"
export PAGER="less"
export LESS=-RF
export SYSTEMD_LESS="RF"
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
export MOZ_ENABLE_WAYLAND=1

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  # wait for amdgpu to initialize
  sleep 2
  exec startplasma-wayland
else
  [[ -f ~/.bashrc ]] && . ~/.bashrc
fi
