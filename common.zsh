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
export SUDO_PROMPT="$(tput setaf 2 bold)Password: $(tput sgr0)"

# FZF configuration.
export FZF_DEFAULT_COMMAND="fd --type file --color=always"
export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border --preview 'bat --color=always --style=numbers {}'"

bindkey "^[[Z" autosuggest-accept # shift + tab  | autosuggest
bindkey "^[[A" history-beginning-search-backward
bindkey "^P" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^N" history-beginning-search-forward

alias v="nvim"
alias ls="lsd"
alias lg="lazygit"
alias config="nvim ~/.zshrc"
alias sysinfo="fastfetch"
alias trim-branches="git branch --merged | grep -v \* | xargs -n 1 git branch -d"
alias destroy-branches="git branch | grep -Ev 'master|develop' | xargs git branch -D"
alias killport=kill-port
alias vf=fzf-edit-file
alias vd=fzf-edit-dir

fzf-edit-file() {
    local file=$(fd --type file --hidden --follow --exclude ".git" . | fzf --preview "bat --color=always --line-range :500 {}")
    if [[ -n $file ]]; then
        nvim "$file"
    fi
}

fzf-edit-dir() {
    local dir=$(fd --type directory --hidden --follow --exclude ".git" . | fzf --preview "eza --tree --color=always {} | head -30")
    if [[ -n $dir ]]; then
        nvim "$dir"
    fi
}

kill-port() {
    local port=$1
    if [[ -z $port ]]; then
        echo "Usage: killport <port>"
        return 1
    fi
    local pid=$(lsof -t -i:$port)
    if [[ -n $pid ]]; then
        kill -9 $pid
        echo "Killed process on port $port (PID: $pid)"
    else
        echo "No process found on port $port"
    fi
}
