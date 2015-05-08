# source
source $HOME/.zsh/zsh-git-prompt/zshrc.sh

# prompt
PROMPT="${fg[cyan]}%n${fg[green]} [%m] ${reset_color}%# "
RPROMPT='$(git_super_status) %~'

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
