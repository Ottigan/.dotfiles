# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sudo
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export VISUAL="nvim"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim="nvim"
alias edge="/Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge"
alias client-start="yarn && yarn start --packages=lobby,andarbahar,ls3,stockmarket,favorite,red-baron"
alias client-start-loc="yarn && yarn start --packages=lobby,andarbahar,ls3,stockmarket,favorite --rewrite /frontend/loc=../localization/target/frontend/loc"
alias client-start-mav="yarn && yarn start --packages=lobby,red-baron --publicPath=/frontend/ibumeteam/red-baron/"
alias client-start-mav-loc="yarn && yarn start --packages=lobby,red-baron --publicPath=/frontend/ibumeteam/red-baron/ --rewrite /frontend/loc=../localization/target/frontend/loc"
alias client-start-hh="yarn && yarn start --packages=hh --publicPath=/frontend/ibumeteam/hh/"
alias dm-ab="yarn start --packages=andar-bahar"
alias dm-ls3="yarn start --packages=ls3"
alias dm-stk="yarn start --packages=stockmarket"
alias dm-stk-storybook="yarn storybook:start --packages=stockmarket"
alias dm-stk-playwright="yarn playwright test --config ./src/stockmarket/playwright/playwright.config.ts"
alias dm-fvt="yarn start --packages=favorite"
alias dm-fvt-storybook="yarn storybook:start --packages=favorite"
alias dm-fvt-playwright="yarn playwright test --config ./src/favorite/playwright/playwright.config.ts"
alias dm-mav="yarn start --packages=red-baron"
alias dm-mav-storybook="yarn storybook:start --packages=red-baron"
alias dm-mav-playwright="yarn playwright test --config ./src/red-baron/playwright/playwright.config.ts"
alias dm-hh="yarn start --packages=hh"
alias dm-hh-storybook="yarn storybook:start --packages=hh"
alias dm-hh-playwright="yarn playwright test --config ./src/hh/playwright/playwright.config.ts"
alias config="nvim ~/.zshrc"
alias killport='f(){ kill -9 $(lsof -i:$1 -t); unset -f f; }; f'
alias trim-branches="git branch --merged | grep -v \* | xargs -n 1 git branch -d"
alias destroy-branches='git branch | grep -v "develop" | xargs git branch -D'
alias ff='f(){ find $1 -type f | fzf; unset -f f; }; f'
alias coverage="http-server -o ./coverage"

unusedFiles() {
    yarn build-validate -p=$1 --unusedFiles=packages/games-evo/evo-$1
}

convertToMp4() {
    ffmpeg -i "$1" -filter:v "scale='trunc(oh*a/2)*2:720',fps=30" -c:a copy "${1%.mov}".mp4
}

convertAllToMp4() {
    for file in *.mov; do
	ffmpeg -i "$file" -filter:v scale="trunc(oh*a/2)*2:720" -c:a copy "${file%.mov}".mp4
    done
}

export PATH="/usr/bin:$PATH"

# homewbrew
export PATH=$PATH:/opt/homebrew/bin

# zig
export PATH=/usr/local/zig:$PATH

# golang
export PATH=$(go env GOPATH)/bin:$PATH

# python
export PATH=/opt/homebrew/opt/python@3.14/libexec/bin:$PATH

# fnm
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env`"
fi

# yarn
export PATH="$(yarn global bin):$PATH"

# bun completions
[ -s "/Users/janismalcans/.bun/_bun" ] && source "/Users/janismalcans/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest

# fzf
export FZF_DEFAULT_OPTS='--preview="bat --color=always {}"'
