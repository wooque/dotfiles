[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

cyan=$'\001\e[1;96m\002'
red=$'\001\e[1;91m\002'
blue=$'\001\e[1;94m\002'
yellow=$'\001\e[1;93m\002'
green=$'\001\e[1;92m\002'
reset_color=$'\001\e[0m\002'

git_status() {
    ret="$(git status -b --porcelain 2> /dev/null)"
    if [[ -z "$ret" ]]; then return; fi
    res=""
    branch=${ret/$'\n'*/}
    branch=${branch/...*/}
    branch=${branch/\#\# /}
    branch=${branch/No commits yet on /}
    if [[ -n $branch ]]; then res="$blue($red$branch$blue) "; fi
    lines=$(wc -l <<< "$ret")
    if [[ $lines -gt 1 ]]; then
        res="$res$yellow× "
    elif [[ "$ret" == *"ahead"* ]]; then
        res="$res$green× "
    fi
    echo "$res"
}

PS1="$cyan\W \$(git_status)$reset_color"

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
