# path
export PATH=$HOME/.nodebrew/current/bin:$PATH

# source
source $HOME/.zsh/zsh-git-prompt/zshrc.sh
# source $HOME/.zsh/resty/resty

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

# z
source ~/.zsh/z/z.sh

# gpg-agent
gpgconf --kill gpg-agent
export "$(gpg-agent -s --enable-ssh-support --daemon)"
export GPG_TTY=$(tty)

# peco functions
function pssh() {
  local res=$(z | aws ec2 describe-instances | jq -r '.Reservations[] | .Instances[] | select(.State.Name == "running") | [(.Tags[] | select(.Key == "Name") | .Value // ""), .PublicIpAddress] | join("\t")' | sort | peco)
  if [ -n "$res" ]; then
    ssh ec2-user@"$(echo "$res" | cut -f2)" -i ~/.ssh/id_comuque_gateway
  else
    return 1
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
    ghq look "$res"
  else
    return 1
  fi
}

function gco() {
  local res=$(git branch -a | cut -c 3- | sed "/remotes\/origin\/HEAD -> origin\/master/d" | sed -e "s/remotes\/origin\///g" | sort | uniq |peco)
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
