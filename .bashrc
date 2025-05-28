case $- in
  *i*) ;;
    *) return;;
esac

if [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

bind 'set match-hidden-files off'
bind 'set enable-bracketed-paste off'
bind 'set completion-ignore-case on'
shopt -s checkwinsize
HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

GIT_PS1_SHOWDIRTYSTATE=true
PROMPT_DIRTRIM=2
PS1='\[\033[01;34m\]\w $(__git_ps1 "\[\033[01;35m\](%s) ")\[\033[00m\]'

show_command_in_title_bar() {
  case "$BASH_COMMAND" in
    history\ *|_z\ *|cd\ *|ls\ *)
      echo -ne "\033]0;${PWD/"$HOME"/\~}\007" 1>&2
      ;;
    *)
      echo -ne "\033]0;${BASH_COMMAND}\007" 1>&2
      ;;
  esac
}
trap show_command_in_title_bar DEBUG

alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lAh --group-directories-first --color=auto"
alias grep="grep -iI --color=auto"
alias diff="diff --color=auto"
alias top="top -c -o%MEM -em -d1.5"
alias ncdu="ncdu --color=off"
alias reset="tput reset"

alias gst="git status"
alias gd="git diff"
alias gdca="git diff --cached"
alias gdt="git difftool -d --cached &"
alias gp="git push"
alias gpf="git push -f"
alias gl="git pull"
alias gld="git stash save && git pull && git stash pop"
alias ga="git add"
alias gcm="git commit -m"
alias gaca="git add . && git commit --amend --no-edit"
alias gco="git checkout"
gcd_func() {
  git stash save && git checkout $1 && git stash pop
}
alias gcd=gcd_func
alias glg="git log"
alias gb="git branch"
alias grh="git reset --hard"
alias grhh="git reset --hard HEAD"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grpo="git remote prune origin"
alias glc="git rev-parse HEAD"
alias gcp="git cherry-pick"
alias gcpc="git cherry-pick --continue"

if [ -r /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
  __git_complete gp _git_push
  __git_complete ga _git_add
  __git_complete gco _git_checkout
  __git_complete gcd _git_checkout
  __git_complete gb _git_branch
  __git_complete grh _git_reset
  __git_complete grb _git_rebase
  __git_complete gcp _git_cherry_pick
fi

alias gitk="gitk &"
alias gdh='diff2html -t "$(basename $PWD) ($(git branch --show-current))"'
alias gdhp="${BASH_ALIASES[gdh]} -- HEAD~1"
alias serve="python3 -m http.server"

if [ -r $HOME/.bash_cmds ]; then
  . $HOME/.bash_cmds
fi
if [ -r $HOME/.z.sh ]; then
  . $HOME/.z.sh
fi
. <(asdf completion bash)
