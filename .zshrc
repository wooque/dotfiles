if type pacman > /dev/null ; then
    ARCH_BASED=true
elif type apt-get > /dev/null ; then
    DEBIAN_BASED=true
elif type yum > /dev/null ; then
    RPM_BASED=true
fi

# Path to your oh-my-zsh installation.
if [[ -d /usr/share/oh-my-zsh/ ]] ; then
    ZSH=/usr/share/oh-my-zsh/
elif [[ -d /home/$USER/.oh-my-zsh/ ]] ; then
    ZSH=/home/$USER/.oh-my-zsh/
elif [[ -d /Users/$USER/.oh-my-zsh ]] ; then
    ZSH=/Users/$USER/.oh-my-zsh/
elif [[ -d /root/.oh-my-zsh ]] ; then
    ZSH=/root/.oh-my-zsh/
else
    echo "Cannot find oh-my-zsh directory"
fi

# autostart tmux on zsh start
if [[ -n $SSH_CONNECTION ]]; then
    ZSH_TMUX_AUTOSTART=false
else
    ZSH_TMUX_AUTOSTART=true
fi
#ZSH_TMUX_AUTOCONNECT=false

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
function () {
    local tmux_plugin
    local dist_plugin

    if [[ -n $ARCH_BASED ]] ; then
        dist_plugin=archlinux
    elif [[ -n $DEBIAN_BASED ]] ; then
        dist_plugin=debian    
    elif [[ -n $RPM_BASED ]] ; then
        dist_plugin=yum
    else
        echo "No disto specific zsh plugin found"
    fi

    if [[ -z $SSH_CONNECTION ]]; then
        tmux_plugin=tmux
    fi

    plugins=(git $tmux_plugin $dist_plugin common-aliases dirhistory last-working-dir sudo systemd z)
}

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

# complete on aliases
#setopt complete_aliases

# User configuration

export PATH=$HOME/.local/bin:$PATH
export GOPATH=/mnt/PODACI/projects/private/go
alias gopath="source gopath"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias free="free -h"
alias top="top -d1"
alias htop="htop -d10"
alias iotop="sudo iotop -oP"
alias df="df -x tmpfs -x devtmpfs -h"
alias dus="du -sh"
alias ll="ls -lh"
alias rm="rm -rf"
alias mv="mv -f"
alias cp="cp -rf"
alias sudo="sudo -E "

if [[ -n $ARCH_BASED ]] ; then
    alias pacstats="expac -HM '%m\t%n' | sort -n"
    alias paccl="sudo rm -rf /var/cache/pacman/pkg/*"
elif [[ -n $DEBIAN_BASED ]] ; then
    alias astats="dpkg-query -Wf '\${Installed-Size}\t\${Package}\n' | sort -n"
    alias apr="sudo apt-get autoremove --purge"
    alias ai="sudo apt-get install"
elif [[ -n $RPM_BASED ]] ; then
    alias rstats="rpm -qa --queryformat '%10{size} - %-25{name} \t %{version}\n' | sort -n"
fi

alias gclf="git clean -f"
alias locate="sudo updatedb && locate"

find_all() {
    find . -iname "*$1*" $2
}
alias fa=find_all

alias zsh_reload="source ~/.zshrc"

