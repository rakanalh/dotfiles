# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="iGeek"
if [ "$INSIDE_EMACS" ]; then
    ZSH_THEME="iGeek"
    PROMPT_EOL_MARK=''
fi
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  autojump
  fzf
)

unsetopt autocd
setopt histignorealldups

# User configuration

export DEFAULT_USER="rakan"

bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey \^U backward-kill-line

stty -ixon

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export TERM=xterm-256color

# export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

export IGNOREEOF=1
export LESS=FRSX

export BROWSER=firefox
export EDITOR=emacs
export PYOPEN_CMD=emacs
export GIT_EDITOR="emacs"
export GTK_THEME=Adwaita:dark

export GOPATH=$HOME/Code/Go
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:/usr/local/go/bin:/opt/sm/bin:/opt/sm/pkg/active/bin:/opt/sm/pkg/active/sbin:$GOROOT/bin:$GOPATH/bin:$HOME/.bin:$HOME/.cargo/bin"

# python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export WORKON_HOME="$HOME/.pyvenvs"

# Other
export DISABLE_AUTO_TITLE='true'

# Emacs
alias emacs="/usr/bin/emacs"
alias e="emacsclient -t -a ''"
alias emacsbare="emacs -nw -Q"
alias eb="emacsbare"
alias ec="e"

# Networking
alias ip1="ipconfig getifaddr en0"
alias ip2="ipconfig getifaddr en1"

# Docker
alias docker-stop-all="docker stop \$(docker ps -a -q)"
alias docker-remove-all="docker rm \$(docker ps -a -q)"
alias docker-update-all="docker images | awk '{print $1}' | xargs -L1 docker pull"

# Arch
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias backlight="dbus-send --system --type=method_call  --dest=\"org.freedesktop.UPower\" \"/org/freedesktop/UPower/KbdBacklight\" \"org.freedesktop.UPower.KbdBacklight.SetBrightness\" int32:$@"

# Tools
alias ls="command ls -hBG"
alias ..='cd ..'
alias edit='$EDITOR $@'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias vag='vagrant $@'
alias vi='vim'
alias cat="bat"
alias ls="exa"
alias tree="exa -T"
# alias grep="rg"
# alias find="fd"
alias cd="z"

source /usr/bin/virtualenvwrapper.sh

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

GPG_TTY=$(tty)
export GPG_TTY
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

source ~/.zshenv
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
