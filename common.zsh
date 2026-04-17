source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest
bindkey '^[[A' history-beginning-search-backward
bindkey '^P' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^N' history-beginning-search-forward

alias ls="lsd"
alias vim="nvim"
alias config="nvim ~/.zshrc"
alias sysinfo="fastfetch"
alias killport='f(){ kill -9 $(lsof -i:$1 -t); unset -f f; }; f'
alias trim-branches="git branch --merged | grep -v \* | xargs -n 1 git branch -d"
alias destroy-branches='git branch | grep -Ev "master|develop" | xargs git branch -D'
alias ff='f(){ find $1 -type f | fzf; unset -f f; }; f'

export EDITOR='nvim'
export VISUAL="nvim"
export PATH="/usr/bin:$PATH"
