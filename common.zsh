source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_STATE_HOME="$HOME/.local/state"

# Make sure this stuff is in the path.
export PATH="$HOME/.nvim/bin:$PATH"  # Neovim
export PATH="$HOME/.cargo/bin:$PATH" # Cargo
export PATH="$HOME/.local/bin:$PATH" # Local scripts
export PATH="$HOME/go/bin:$PATH"     # Go binaries.

# Use neovim as the default editor.
export EDITOR="$HOME/.nvim/bin/nvim"
export VISUAL="$HOME/.nvim/bin/nvim"

# Colorful sudo prompt.
SUDO_PROMPT="$(tput setaf 2 bold)Password: $(tput sgr0)" && export SUDO_PROMPT

bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest
bindkey '^[[A' history-beginning-search-backward
bindkey '^P' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^N' history-beginning-search-forward

alias ls="lsd"
alias vim="nvim"
alias lg="lazygit"
alias config="nvim ~/.zshrc"
alias sysinfo="fastfetch"
alias killport='f(){ kill -9 $(lsof -i:$1 -t); unset -f f; }; f'
alias trim-branches="git branch --merged | grep -v \* | xargs -n 1 git branch -d"
alias destroy-branches='git branch | grep -Ev "master|develop" | xargs git branch -D'
alias ff='f(){ find $1 -type f | fzf; unset -f f; }; f'
