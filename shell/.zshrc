# ══════════════════════════════════════════════════════════════════
# ZINIT
# ══════════════════════════════════════════════════════════════════

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Oh-My-Zsh snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::dnf
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::eza
zinit snippet OMZP::gh
zinit snippet OMZP::npm
zinit snippet OMZP::rust
zinit snippet OMZP::ssh
zinit snippet OMZP::tmux
zinit snippet OMZP::zoxide

# Completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# ══════════════════════════════════════════════════════════════════
# SHELL OPTIONS
# ══════════════════════════════════════════════════════════════════

export DEFAULT_USER="rakan"

unsetopt autocd
stty -ixon

# ══════════════════════════════════════════════════════════════════
# HISTORY
# ══════════════════════════════════════════════════════════════════

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ══════════════════════════════════════════════════════════════════
# COMPLETION STYLING
# ══════════════════════════════════════════════════════════════════

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ══════════════════════════════════════════════════════════════════
# KEY BINDINGS
# ══════════════════════════════════════════════════════════════════

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey '^U' backward-kill-line

# ══════════════════════════════════════════════════════════════════
# ALIASES
# ══════════════════════════════════════════════════════════════════

# --- Emacs ---
alias emacs="/usr/bin/emacs"
alias e="emacsclient -t -a ''"
alias ec="e"
alias emacsbare="emacs -nw -Q"
alias eb="emacsbare"

# --- Docker ---
alias docker-stop-all='docker stop $(docker ps -a -q)'
alias docker-remove-all='docker rm $(docker ps -a -q)'
alias docker-update-all="docker images | awk '{print \$1}' | xargs -L1 docker pull"

# --- System ---
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias backlight='dbus-send --system --type=method_call --dest="org.freedesktop.UPower" "/org/freedesktop/UPower/KbdBacklight" "org.freedesktop.UPower.KbdBacklight.SetBrightness" int32:$@'

# --- Navigation ---
alias ..='cd ..'
alias cd="z"

# --- Tools ---
alias vi="nvim"
alias edit='$EDITOR $@'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias vag='vagrant $@'
alias claude="~/.claude/local/claude"
alias tm="task-master"
alias taskmaster="task-master"

# ══════════════════════════════════════════════════════════════════
# FUNCTIONS
# ══════════════════════════════════════════════════════════════════

function lastcommandfailed() {
    code=$?
    if [ $code != 0 ]; then
        echo -n $'\033[37;1m exited \033[31;1m'
        echo -n $code
        echo -n $'\033[37;1m'
    fi
}

function cleanpycs() {
    find . -name "*.pyc" -exec rm -rf {} \;
}

# ══════════════════════════════════════════════════════════════════
# TOOL INITIALIZATION
# ══════════════════════════════════════════════════════════════════

# Python virtualenvwrapper
source /usr/bin/virtualenvwrapper.sh

# GPG agent
gpgconf --launch gpg-agent

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Shell enhancements
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(just --completions zsh)"
