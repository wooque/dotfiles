[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=1000
HISTSIZE=1000
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

cyan=$'\001\e[96m\002'
red=$'\001\e[91m\002'
blue=$'\001\e[94m\002'
yellow=$'\001\e[93m\002'
orange=$'\001\e[33m\002'
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
        res="$res$orange× "
    fi
    echo "$res"
}

PS1="$cyan\W \$(git_status)$reset_color"

source ~/.shrc
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
