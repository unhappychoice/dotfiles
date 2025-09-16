# path
export PATH=/usr/local/sbin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# source
source $HOME/.zsh/zsh-git-prompt/zshrc.sh
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
# source $HOME/.zsh/resty/resty

# initialize
. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"

eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

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
alias gp="gpmn && gpms && gps && gps"
alias gpmn="git branch --merged main | grep -vE '^\*|main$|master$|develop$|staging$' | xargs -I % git branch -d %"
alias gpms="git branch --merged master | grep -vE '^\*|main$|master$|develop$|staging$' | xargs -I % git branch -d %"
alias gpd="git branch --merged develop | grep -vE '^\*|main$|master$|develop$|staging$' | xargs -I % git branch -d %"
alias gps="git branch --merged staging | grep -vE '^\*|main$|master$|develop$|staging$' | xargs -I % git branch -d %"

alias fuck='$(thefuck $(fc -ln -1))'

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# z
source ~/.zsh/z/z.sh

# gpg-agent
# gpgconf --kill gpg-agent
# export "$(gpg-agent -s --enable-ssh-support --daemon)"
export GPG_TTY=$(tty)

# history settings
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt inc_append_history

# television functions
function pssh() {
  local host=$(tv -s "grep -r 'Host ' $HOME/.ssh/* | cut -d' ' -f2 | sort")

  if [ ! -z "$host" ]; then
    ssh "$host"
  fi
}

function pcd() {
  local res=$(tv z-dirs)
  if [ -n "$res" ]; then
    # Expand ~ back to $HOME for cd command
    local expanded_path="${res/#\~/$HOME}"
    cd "$expanded_path"
  else
    return 1
  fi
}

function gcd() {
  local res=$(tv ghq)
  if [ -n "$res" ]; then
    cd "$(ghq root)/$res"
  else
    return 1
  fi
}

function gco() {
  local res=$(tv git-branch)
  if [ -n "$res" ]; then
    # Check if it's a remote branch (starts with origin/)
    if [[ "$res" == origin/* ]]; then
      # Extract the local branch name (remove origin/ prefix)
      local local_branch="${res#origin/}"
      git checkout "$local_branch"
    else
      git checkout "$res"
    fi
  else
    return 1
  fi
}

function gbr() {
  local res=$(tv ghq)
  if [ -n "$res" ]; then
    if [[ -n "$WSL_DISTRO_NAME" || $(uname -r) == *microsoft* ]]; then
      # WSL environment
      if command -v wslview >/dev/null 2>&1; then
        wslview "https://$res"
      elif command -v explorer.exe >/dev/null 2>&1; then
        explorer.exe "https://$res"
      else
        echo "https://$res"
      fi
    else
      # Native Linux/macOS
      if command -v open >/dev/null 2>&1; then
        open "https://$res"
      elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "https://$res"
      else
        echo "https://$res"
      fi
    fi
  else
    return 1
  fi
}

function pgrep() {
  local result=$(tv text)
  if [ -n "$result" ]; then
    bat --style=numbers --color=always "$result"
  fi
}

function nr() {
  local script=$(tv npm-scripts)
  if [ -n "$script" ]; then
    npm run "$script"
  fi
}

function hr() {
  local cmd=$(tv zsh-history)
  if [ -n "$cmd" ]; then
    eval "$cmd"
  fi
}
