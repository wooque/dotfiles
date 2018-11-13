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
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})"

PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

SAVEHIST=1000
HISTSIZE=1000

alias r=ranger
alias v=vim
alias free="free -h"
alias top="top -d1"
alias htop="htop -d10"
alias psmem="sudo ps_mem"
alias slabtop="sudo slabtop -s c"
alias iotop="sudo iotop -oP"
alias df="df -x tmpfs -x devtmpfs -h"
alias dus="du -sh"
alias ll="ls -lh"
alias rm="rm -rf"
alias mv="mv -f"
alias cp="cp -rf"
alias sudo="sudo -E "
alias cleartmp="rm -rf /tmp"
alias clearcache="sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias gclf="git clean -f"
alias locate="sudo updatedb && locate"
alias zshreload="source ~/.zshrc"

if [[ $dist_plugin == "archlinux" ]] ; then
    alias pacstats="expac -HM '%m\t%n' | sort -n"
    alias paccl="sudo rm -rf /var/cache/pacman/pkg/*"
    alias yaupg="yaupg.sh"
elif [[ $dist_plugin == "debian" ]] ; then
    alias astats="dpkg-query -Wf '\${Installed-Size}\t\${Package}\n' | sort -n"
    alias apr="sudo apt-get autoremove --purge"
    alias ai="sudo apt-get install"
elif [[ $dist_plugin == "yum" ]] ; then
    alias rstats="rpm -qa --queryformat '%10{size} - %-25{name} \t %{version}\n' | sort -n"
fi

mpv_play() {
    nohup mpv "$@" &> /dev/null &; disown
}

alias mpv=mpv_play
alias yt="mpv_play --ytdl-format 22"
alias yta="mpv_play --ytdl-format 140"

find_all() {
    find . -iname "*$1*" "${@:2}"
}
alias fa=find_all
