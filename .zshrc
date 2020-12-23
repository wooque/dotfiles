SAVEHIST=4096
HISTSIZE=4096
HISTFILE="$HOME/.zsh_history"
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

cyan=$'%{\e[1;96m%}'
red=$'%{\e[1;91m%}'
blue=$'%{\e[1;94m%}'
yellow=$'%{\e[1;93m%}'
green=$'%{\e[1;92m%}'
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
        res="$res$green× "
    fi
    echo "$res"
}

setopt PROMPT_SUBST
PROMPT="$cyan%c \$(git_status)$reset_color"

eval "$(fasd --init auto)"
source ~/.shrc

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

bindkey "${terminfo[khome]}"    beginning-of-line
bindkey "${terminfo[kend]}"     end-of-line
bindkey "${terminfo[kdch1]}"    delete-char
bindkey "${terminfo[kpp]}"      beginning-of-buffer-or-history
bindkey "${terminfo[knp]}"      end-of-buffer-or-history
bindkey '^R' history-incremental-search-backward

alias -g G='| grep'

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
