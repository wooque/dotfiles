[[ $- != *i* ]] && return

bind 'set match-hidden-files off'
bind 'set enable-bracketed-paste off'
HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=10000
HISTSIZE=10000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

GIT_PS1_SHOWDIRTYSTATE=true
if [[ -r "/usr/share/git/completion/git-prompt.sh" ]]; then
    source /usr/share/git/completion/git-prompt.sh
fi

PROMPT_DIRTRIM=2
PS1='\[\e[1;34m\]\w $(__git_ps1 "\[\e[1;35m\](%s) ")\[\e[0m\]'

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -lAh --group-directories-first --color=auto"
alias grep="grep -iI --color=auto"
alias diff="diff --color=auto"
function rr() {
  cmd=$(history -p !!)
  new_cmd="sudo $cmd"
  echo "$new_cmd"
  history -s "$new_cmd"
  $new_cmd
}
export -f rr

if [[ -r "/usr/share/git/completion/git-completion.bash" ]]; then
  source "/usr/share/git/completion/git-completion.bash"
fi

alias gst="git status"
alias gd="git diff"
alias gdca="git diff --cached"
alias gp="git push"
alias gl="git pull"
alias ga="git add"
__git_complete ga _git_add
alias gcm="git commit -m"
alias gco="git checkout"
__git_complete gco _git_checkout
alias glg="git log"
alias gb="git branch"
__git_complete gb _git_branch
alias grhh="git reset --hard HEAD"

alias upgrade="yay -Syu --combinedupgrade"
alias backup="rsync -azzP --delete --exclude-from='/mnt/PODACI/.backupignore' /mnt/PODACI backup:/root/backup | tee -a ~/backup.log"

[[ -r "/opt/asdf-vm/asdf.sh" ]] && source /opt/asdf-vm/asdf.sh
