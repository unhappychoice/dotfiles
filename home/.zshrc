# path
export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH

# source
source $HOME/.zsh/zsh-git-prompt/zshrc.sh
# source $HOME/.zsh/resty/resty

# prompt
eval "$(starship init zsh)"

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
alias gd='git diff'
alias gp='git push'
alias gs='git status'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gla="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gp="git branch --merged master | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d %"
alias gps="git branch --merged staging | grep -vE '^\*|master$|develop$|staging$' | xargs -I % git branch -d %"
alias gpd="git branch --merged develop | grep -vE '^\*|master$|develop$|staging$' | xargs -I % git branch -d %"

alias fuck='$(thefuck $(fc -ln -1))'

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# rbenv
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook zsh)"

# z
source ~/.zsh/z/z.sh

# gpg-agent
gpgconf --kill gpg-agent
export "$(gpg-agent -s --enable-ssh-support --daemon)"
export GPG_TTY=$(tty)

# peco functions
function pssh() {
  local host=$(grep -r 'Host ' $HOME/.ssh/* | cut -d' ' -f2 | sort | peco)

  if [ ! -z "$host" ]; then
    ssh "$host"
  fi
}

function pcd() {
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    cd "$res"
  else
    return 1
  fi
}

function gcd() {
  local res=$(ghq list | sort | peco)
  if [ -n "$res" ]; then
    ghq get --look "$res"
  else
    return 1
  fi
}

function gco() {
  local res=$(git branch -a | cut -c 3- | sed "/remotes\/origin\/HEAD -> origin\/master/d" | sed "/remotes\/origin\/HEAD -> origin\/staging/d" | sed -e "s/remotes\/origin\///g" | sort | uniq |peco)
  if [ -n "$res" ]; then
    git checkout "$res"
  else
    return 1
  fi
}

function gbr() {
  local res=$(ghq list | sort | peco)
  if [ -n "$res" ]; then
    open "https://$res"
  else
    return 1
  fi
}

function pgrep() {
  ack "$@" . | peco --initial-filter CaseSensitive --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less '
}
