# ================================
# General Environment Variables
# ================================
export ZSH="$HOME/.oh-my-zsh"
export LANG=C.UTF-8 
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export XDG_CONFIG_HOME="$HOME/repos"
export GOPATH="$HOME/go"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${GOPATH}/bin:$HOME/.atuin/bin:$PATH

# ================================
# Prompt Configuration
# ================================

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Oh My Zsh Configuration
# ================================
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Oh My Zsh Update Settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1
HIST_STAMPS="yyyy-mm-dd"

# ================================
# Autocompletion
# ================================
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ================================
# Editor Configuration
# ================================
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

alias v="/opt/nvim-linux64/bin/nvim"

# ================================
# Plugins and Extensions
# ================================
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Atuin for enhanced history
eval "$(atuin init zsh)"

# Direnv for directory-specific environments
eval "$(direnv hook zsh)"

# FZF Integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ================================
# Useful Aliases
# ================================

# General Aliases
alias cl='clear'
alias la=tree
alias cat=batcat
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# Git Aliases
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias gswc="git switch -c"
alias gsw="git switch"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -D'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker Aliases
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Directory Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Enhanced Directory Listings
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# HTTP Requests
alias http="xh"

# Function to categorize and list aliases
list_aliases() {
    echo "General Aliases:"
    grep -E '^alias ' ~/.zshrc | grep -Ev 'git|docker' | sed -E 's/^alias //'
    echo
    echo "Git Aliases:"
    grep -E '^alias ' ~/.zshrc | grep 'git' | sed -E 's/^alias //'
    echo
    echo "Docker Aliases:"
    grep -E '^alias ' ~/.zshrc | grep 'docker' | sed -E 's/^alias //'
}

alias aliases="list_aliases"


# ================================
# Functions
# ================================
# Function to navigate and list directory contents
cx() { cd "$@" && l; }

# Navigate to a directory using FZF
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }

# Find a file and copy its path
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }

# Open a file selected via FZF in Neovim
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# ================================
# SSH Agent
# ================================
start-ssh-agent() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
}

alias dotfiles='git --git-dir=/home/bxtal/dotfiles/.git --work-tree=/home/bxtal'
