[[ $- != *i* ]] && return

bind 'set match-hidden-files off'
bind 'set enable-bracketed-paste off'
shopt -s histappend
shopt -s checkwinsize
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

GIT_PS1_SHOWDIRTYSTATE=true
if [[ -r "/usr/share/git/completion/git-prompt.sh" ]]; then
    source /usr/share/git/completion/git-prompt.sh
fi

PROMPT_DIRTRIM=2
PS1='\[\033[01;34m\]\w $(__git_ps1 "\[\033[01;35m\](%s) ")\[\033[00m\]'

alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lAh --group-directories-first --color=auto"
alias grep="grep -iI --color=auto"
alias diff="diff --color=auto"
alias top="top -c -o%MEM -em -d1.5"
alias ncdu="ncdu --color=off"

if [[ -r "/usr/share/git/completion/git-completion.bash" ]]; then
  source "/usr/share/git/completion/git-completion.bash"
fi

alias gst="git status"
alias gd="git diff"
alias gdca="git diff --cached"
alias gp="git push"
__git_complete gp _git_push
alias gl="git pull"
alias ga="git add"
__git_complete ga _git_add
alias gcm="git commit -m"
alias gca="git add . && git commit --amend --no-edit"
alias gco="git checkout"
__git_complete gco _git_checkout
alias glg="git log"
alias gb="git branch"
__git_complete gb _git_branch
alias grhh="git reset --hard HEAD"

alias upgrade="yay -Syu --combinedupgrade"
alias backup="rsync -azzP --delete --exclude-from='/mnt/PODACI/.backupignore' /mnt/PODACI backup:/root/backup | tee ~/backup-\$(date +%Y-%m-%d-%H-%M-%S).log"

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[[ -r "/opt/asdf-vm/asdf.sh" ]] && source /opt/asdf-vm/asdf.sh
