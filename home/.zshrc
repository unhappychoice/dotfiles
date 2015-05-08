# alias
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# rbenv
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook zsh)"
