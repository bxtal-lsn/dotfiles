# ================================
# General Environment Variables
# ================================
set -x LANG C.UTF-8
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x GOPATH "$HOME/go"
set -x PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin $HOME/.atuin/bin $PATH
set -x PATH $PATH /snap/bin
set -x PATH $HOME/.zig/zig-linux-x86_64-0.13.0 $PATH
set -x PATH $PATH /opt/mssql-tools18/bin
set -x PASSWORD_STORE_CLIPBOARD_COMMAND "~/.local/bin/win32yank.exe -i"
set -x PATH $PATH /usr/local/bin
set -x PATH $HOME/.scripts $PATH
set -x PATH $HOME/.local/bin/ $PATH

# ================================
# Editor Configuration
# ================================
if test -n "$SSH_CONNECTION"
    set -x EDITOR 'vim'
else
    set -x EDITOR 'nvim'
end

# ================================
# Plugins and Extensions
# ================================

atuin init fish | source
direnv hook fish | source

set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow'
test -f ~/.config/fish/functions/fzf_key_bindings.fish && source ~/.config/fish/functions/fzf_key_bindings.fish

# Keyboard layout
command -q setxkbmap && setxkbmap dk

# ================================
# Useful Aliases
# ================================
# General Aliases/Abbreviations
abbr -a cl 'clear'
abbr -a la 'tree'
abbr -a cat 'bat'
abbr v "/opt/nvim-linux-x86_64/bin/nvim"
abbr -a md "mkdir"
abbr -a mdp "mkdir -p"
abbr -a rmr "rm -r"

# Git Abbreviations
abbr -a gc "git commit -m"
abbr -a gp "git push origin HEAD"
abbr -a gpu "git pull origin"
abbr -a gst "git status"
abbr -a gswc "git switch -c"
abbr -a gsw "git switch"
abbr -a glog "git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
abbr -a gdiff "git diff"
abbr -a gb 'git branch'
abbr -a gba 'git branch -a'
abbr -a gbd 'git branch -D'
abbr -a gadd 'git add'

# Docker Abbreviations
abbr -a dco "docker compose"
abbr -a dps "docker ps"
abbr -a dpa "docker ps -a"
abbr -a dl "docker ps -l -q"
abbr -a dx "docker exec -it"

# Directory Navigation
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a ..... "cd ../../../.."
abbr -a ...... "cd ../../../../.."
abbr -a l "eza -l --git"
abbr -a l1 "eza --tree --level=2 --long --git"
abbr -a l2 "eza --tree --level=3 --long --no-permissions --no-user --no-time"
abbr -a l3 "eza --tree --level=4 --no-permissions --no-user --no-time --no-filesize"

# Function to list abbreviations
function list_aliases
    echo "General Abbreviations:"
    abbr | grep -v 'git\|docker' 
    echo
    echo "Git Abbreviations:"
    abbr | grep 'git'
    echo
    echo "Docker Abbreviations:"
    abbr | grep 'docker'
end
abbr -a aliases "list_aliases"

# ================================
# Functions
# ================================
# Find a file and copy its path
function sc
    echo (find . -type f -not -path '*/.*' | fzf) | clip.exe
end

# Open a file selected via FZF in Neovim
function sf
    nvim (find . -type f -not -path '*/.*' | fzf)
end

# ================================
# SSH Agent
# ================================
function start-ssh-agent
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/bitbucket
end

set fish_greeting ""

if status is-interactive
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end
