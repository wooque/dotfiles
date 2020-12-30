[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

GIT_PS1_SHOWDIRTYSTATE=true

if [[ -r "/usr/share/git/completion/git-prompt.sh" ]]; then
    source /usr/share/git/completion/git-prompt.sh
elif [[ -r "/usr/lib/git-core/git-sh-prompt" ]]; then
    source /usr/lib/git-core/git-sh-prompt
fi
PS1='\[\e[1;36m\]\W $(__git_ps1 "\[\e[1;94m\](\[\e[1;31m\]%s\[\e[1;94m\]) ")\[\e[0m\]'

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lAh --group-directories-first --color=auto"
alias grep="grep -iI --color=auto"
alias diff="diff --color=auto"
alias rr='sudo $(history -p !!)'

alias gst="git status"
alias gd="git diff"
alias gdca="git diff --cached"
alias gp="git push"
alias gl="git pull"
alias ga="git add"
alias gcm="git commit -m"
alias gco="git checkout"

function qemu() {
  qemu-system-x86_64 -daemonize -enable-kvm -cpu host -smp 4,cores=2 -m 2048 -usb -device usb-tablet -device intel-hda -device hda-duplex -drive file="$1" "${@:2}"
}
export -f qemu
alias qemuimg="qemu-img create -f qcow2"

alias upgrade="yay -Syu --combinedupgrade"
