export ZSH="$HOME/.oh-my-zsh/"
ZSH_THEME=""

#ENABLE_CORRECTION="true"
#COMPLETION_WAITING_DOTS="true"

if type pacman > /dev/null ; then
    dist_plugin=archlinux
elif type apt-get > /dev/null ; then
    dist_plugin=debian
elif type yum > /dev/null ; then
    dist_plugin=yum
fi

plugins=(git $dist_plugin common-aliases dirhistory last-working-dir sudo systemd z)

source $ZSH/oh-my-zsh.sh

# User configuration
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%}) %{$fg[yellow]%}×"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})"

PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

SAVEHIST=1000
HISTSIZE=1000

export LESS=-R
export LESS_TERMCAP_md=$'\E[1;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export SYSTEMD_LESS="FRSMK"

alias r=ranger
alias v=vim
alias ll="ls -lh"
alias rm="rm -rf"
alias mv="mv -f"
alias cp="cp -rf"
alias grep="grep -iI --color=auto"
alias diff="diff --color=auto"
alias sudo="sudo -E "
alias free="free -h"
alias top="top -d1"
alias htop="htop -d10"
alias psmem="sudo ps_mem"
alias slabtop="sudo slabtop -s c"
alias iotop="sudo iotop -oP"
alias df="df -x tmpfs -x devtmpfs -h"
alias dus="du -sh"
alias ncdu="ncdu --color dark"
alias cleartmp="rm -rf /tmp"
alias clearcache="sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias gclf="git clean -f"
alias locate="sudo updatedb && locate"
alias zshreload="source ~/.zshrc"
alias ytd="youtube-dl -f 22"
alias ytda="youtube-dl -f 140"

if [[ $dist_plugin == "archlinux" ]] ; then
    alias pacstats="expac -HM '%m\t%n' | sort -n"
    alias paccl="sudo rm -rf /var/cache/pacman/pkg/*"
    alias yaupg="$HOME/.scripts/yaupg"
elif [[ $dist_plugin == "debian" ]] ; then
    alias astats="dpkg-query -Wf '\${Installed-Size}\t\${Package}\n' | sort -n"
    alias apr="sudo apt-get autoremove --purge"
    alias ai="sudo apt-get install"
elif [[ $dist_plugin == "yum" ]] ; then
    alias rstats="rpm -qa --queryformat '%10{size} - %-25{name} \t %{version}\n' | sort -n"
fi

open() {
    if [[ $# -eq 0 ]]; then return; fi
    nohup xdg-open "$@" &> /dev/null &; disown
}
alias o=open

find_all() {
    find . -iname "*$1*" "${@:2}"
}
alias fa=find_all
