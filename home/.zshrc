# path
export PATH=$HOME/.nodebrew/current/bin:$PATH

# source
source $HOME/.zsh/zsh-git-prompt/zshrc.sh

# prompt
PROMPT="${fg[cyan]}%n${fg[green]} [%m] ${reset_color} %~ \$(git-radar --zsh) 
%# "

# completion
fpath=(/usr/local/share/zsh-completions $fpath)	
autoload -U compinit
compinit -u

# alias
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"

alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gp='git push'
alias gs='git status'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gla="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

alias fuck='$(thefuck $(fc -ln -1))'

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# rbenv
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook zsh)"
