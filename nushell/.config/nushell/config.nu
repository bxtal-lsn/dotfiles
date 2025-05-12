# ------------------------
# History-related settings
# ------------------------
# $env.config.history.*

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.history.sync_on_enter = true

# ----------------------
# Miscellaneous Settings
# ----------------------

$env.config.show_banner = false
$env.config.rm.always_trash = false

# ---------------------------
# Commandline Editor Settings
# ---------------------------

$env.config.edit_mode = "vi"
$env.config.buffer_editor = "vi"

# --------------------
# Completions Behavior
# --------------------

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.sort = "smart"
$env.config.completions.case_sensitive = false

# ---------------------------------------------------------------------------------------
# Environment Variables
# ---------------------------------------------------------------------------------------

$env.PROMPT_COMMAND = "Nushell"
$env.PATH ++= [ "~/.local/bin" ]

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# -------
# Aliases
# -------

# General Aliases
alias cl = clear
alias la = tree
alias cat = batcat
alias pbcopy = xclip -selection clipboard
alias pbpaste = xclip -selection clipboard -o
alias v = /opt/nvim-linux-x86_64/bin/nvim
alias md = mkdir

# Git Aliases
alias gc = git commit -m 
alias gca = git commit -a -m 
alias gp = git push origin HEAD 
alias gpu = git pull origin 
alias gst = git status 
alias gswc = git switch -c 
alias gsw = git switch 
alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
alias gdiff = git diff
alias gb = git branch
alias gba = git branch -a
alias gbd = git branch -D
alias gadd = git add

# Docker Aliases
alias dco = docker compose
alias dps = docker ps
alias dpa = docker ps -a
alias dl = docker ps -l -q
alias dx = docker exec -it

# Directory Navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ...... = cd ../../../../..

alias l = eza -l --git
alias l1 = eza --tree --level=2 --long --git
alias l2 = eza --tree --level=3 --long --no-permissions --no-user --no-time
alias l3 = eza --tree --level=4 --no-permissions --no-user --no-time --no-filesize

