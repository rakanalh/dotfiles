# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
. "$HOME/.cargo/env"

export PATH="$PATH:/home/rakan/.risc0/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# KGoogleTasks environment
source /home/rakan/.local/bin/kgoogletasks-env.sh
export PYTHONPATH="/home/rakan/.local/share/qt6/qml/org/kde/plasma/private/kgoogletasks:$PYTHONPATH"

export GOPATH=$HOME/Code/Go
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:/usr/local/go/bin:/opt/sm/bin:/opt/sm/pkg/active/bin:/opt/sm/pkg/active/sbin:/var/lib/snapd/snap/bin/:/etc/alternatives/:$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin:$HOME/.bin:$HOME/.config/emacs/bin/:$HOME/.cargo/bin:/home/rakan/.foundry/bin:/home/rakan/.risc0/bin:/home/rakan/.claude/local"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export TERM=xterm-256color

# export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

export IGNOREEOF=1
export LESS=FRSX

export BROWSER=firefox
export EDITOR=emacs
export PYOPEN_CMD=emacs
export GIT_EDITOR="emacs"
export GTK_THEME=Adwaita:dark
export XDG_CURRENT_DESKTOP="hyprland"

# python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export WORKON_HOME="$HOME/.pyvenvs"

export GPG_TTY=$(tty)

# Other
export DISABLE_AUTO_TITLE='true'

export PATH="$PATH:/home/rakan/.sp1/bin"

# uv
export PATH="/home/rakan/.local/bin:$PATH"

eval "$(direnv hook bash)"
