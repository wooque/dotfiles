[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=1000
HISTSIZE=1000
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

cyan=$'\001\e[96m\002'
red=$'\001\e[91m\002'
blue=$'\001\e[94m\002'
yellow=$'\001\e[93m\002'
reset_color=$'\001\e[0m\002'

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

PS1="$cyan\W \$(git_branch)\$(git_status)$reset_color"

source ~/.shrc
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
