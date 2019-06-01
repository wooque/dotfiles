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
orange=$'%{\e[33m%}'
reset_color=$'%{\e[0m%}'

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
        res="$res$orange× "
    fi
    echo "$res"
}

setopt PROMPT_SUBST
PROMPT="$cyan%c \$(git_status)$reset_color"

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
