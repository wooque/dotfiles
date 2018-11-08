if type pacman > /dev/null ; then
    ARCH_BASED=true
elif type apt-get > /dev/null ; then
    DEBIAN_BASED=true
elif type yum > /dev/null ; then
    RPM_BASED=true
fi

ZSH="$HOME/.oh-my-zsh/"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
if [[ -n $ARCH_BASED ]] ; then
    dist_plugin=archlinux
elif [[ -n $DEBIAN_BASED ]] ; then
    dist_plugin=debian
elif [[ -n $RPM_BASED ]] ; then
    dist_plugin=yum
else
    dist_plugin=""
    echo "No disto specific zsh plugin found"
fi

plugins=(git $dist_plugin common-aliases dirhistory last-working-dir sudo systemd z)

source $ZSH/oh-my-zsh.sh

# User configuration
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

if [[ -n $ARCH_BASED ]] ; then
    alias pacstats="expac -HM '%m\t%n' | sort -n"
    alias paccl="sudo rm -rf /var/cache/pacman/pkg/*"
    alias yaupg="yaupg.sh"
elif [[ -n $DEBIAN_BASED ]] ; then
    alias astats="dpkg-query -Wf '\${Installed-Size}\t\${Package}\n' | sort -n"
    alias apr="sudo apt-get autoremove --purge"
    alias ai="sudo apt-get install"
elif [[ -n $RPM_BASED ]] ; then
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
