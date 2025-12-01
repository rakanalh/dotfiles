# ══════════════════════════════════════════════════════════════════
# LOCALE
# ══════════════════════════════════════════════════════════════════

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ══════════════════════════════════════════════════════════════════
# PATH
# ══════════════════════════════════════════════════════════════════

typeset -U path  # Remove duplicates

path=(
    $HOME/.local/bin
    $HOME/.bin
    $HOME/.cargo/bin
    $HOME/.foundry/bin
    $HOME/.risc0/bin
    $HOME/.sp1/bin
    $HOME/.claude/local
    $HOME/.config/emacs/bin
    $HOME/Code/Go/bin
    /usr/local/go/bin
    /usr/local/bin
    /usr/local/git/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /var/lib/snapd/snap/bin
    /etc/alternatives
    /opt/sm/bin
    /opt/sm/pkg/active/bin
    /opt/sm/pkg/active/sbin
    $path
)

export GOPATH=$HOME/Code/Go

# ══════════════════════════════════════════════════════════════════
# EDITORS & TOOLS
# ══════════════════════════════════════════════════════════════════

export EDITOR=nvim
export GIT_EDITOR=nvim
export PYOPEN_CMD=nvim
export BROWSER=firefox

# ══════════════════════════════════════════════════════════════════
# PYTHON
# ══════════════════════════════════════════════════════════════════

export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export WORKON_HOME="$HOME/.pyvenvs"
export UV_PYTHON=python3.12

# ══════════════════════════════════════════════════════════════════
# DESKTOP / DISPLAY
# ══════════════════════════════════════════════════════════════════

export TERM=xterm-256color
export GTK_THEME=Adwaita:dark
export XDG_CURRENT_DESKTOP=hyprland

# ══════════════════════════════════════════════════════════════════
# GPG / SSH
# ══════════════════════════════════════════════════════════════════

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# ══════════════════════════════════════════════════════════════════
# API KEYS (loaded from pass on demand)
# ══════════════════════════════════════════════════════════════════

export OPENAI_API_KEY="$(pass show api/openai 2>/dev/null)"

# ══════════════════════════════════════════════════════════════════
# MISC
# ══════════════════════════════════════════════════════════════════

export IGNOREEOF=1
export LESS=FRSX
export DISABLE_AUTO_TITLE=true
