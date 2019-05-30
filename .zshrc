SAVEHIST=1000
HISTSIZE=1000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

cyan=$'%{\e[96m%}'
red=$'%{\e[91m%}'
blue=$'%{\e[94m%}'
yellow=$'%{\e[93m%}'
reset_color=$'%{\e[0m%}'

git_branch() {
    ret="$(git branch 2> /dev/null | grep \* | cut -d ' ' -f2)"
    if [[ -n $ret ]]; then
        echo "$blue($red$ret$blue) "
    fi
}

git_status () {
    ret="$(git status -s 2> /dev/null)"
    if [[ -n $ret ]]; then
        echo "$yellow× "
    fi
}

setopt PROMPT_SUBST
PROMPT="$cyan%c \$(git_branch)\$(git_status)$reset_color"

source ~/.shrc
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

bindkey "${terminfo[khome]}"    beginning-of-line
bindkey "${terminfo[kend]}"     end-of-line
bindkey "${terminfo[kdch1]}"    delete-char
bindkey "${terminfo[kpp]}"      beginning-of-buffer-or-history
bindkey "${terminfo[knp]}"      end-of-buffer-or-history
bindkey '^R' history-incremental-search-backward
