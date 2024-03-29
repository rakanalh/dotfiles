#!/bin/bash

# Inspired greatly by David Cramer bashrc
# https://github.com/dcramer/dotfiles/blob/master/bash/bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1=" > \W\$(parse_git_branch) \\$ "

function lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo -n $'\033[37;1m exited \033[31;1m'
    echo -n $code
    echo -n $'\033[37;1m'
  fi
}

export ARCHFLAGS='-arch i386 -arch x86_64'

export TERM=xterm-color

export CLICOLOR=1
if [ `uname` == "Darwin" ]; then
  export LSCOLORS=ExGxFxDxCxHxHxCbCeEbEb
  export LC_CTYPE=en_US.utf-8
  alias free=tfree
else
  alias ls='ls --color=auto'
fi

export IGNOREEOF=1
export LESS=FRSX

export EDITOR=emacs
export PYOPEN_CMD=emacs
export GIT_EDITOR=$EDITOR

export ANDROID_HOME=/Users/rakan/Library/Android/sdk/
export PROJECT_HOME=$HOME/Code/Python/
export GOPATH=$HOME/Code/Go

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:/usr/local/go/bin:/opt/sm/bin:/opt/sm/pkg/active/bin:/opt/sm/pkg/active/sbin:{$ANDROID_HOME}platform-tools/:$GOROOT/bin:$GOPATH/bin:~/.bin:~/.bin"

# python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP="$HOME/.pythonrc.py"

# Enable bash history
export HISTCONTROL=erasedups
export HISTSIZE=5000
shopt -s histappend

# we always pass these to ls(1)
LS_COMMON="-hBG"

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"

# These set up/down to do the history searching
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

alias ..='cd ..'

alias edit='$EDITOR $@'

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

alias vag='vagrant $@'

function cleanpycs() {
  find . -name "*.pyc" -exec rm -rf {} \;
}

if [ -e "$HOME/.local-bashrc" ]; then
  source "$HOME/.local-bashrc"
fi

# Use git-completion if available
if [ -e "$HOME/.git-completion.bash" ]; then
  source "$HOME/.git-completion.bash"
fi;

# Use bash-completion, if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi

# GRC support
if [ `uname` == "Darwin" ]; then
  grc_bash="`brew --prefix grc`/etc/grc.bashrc"
  if [ -e "$grc_bash" ]; then
    source "$grc_bash"
  fi;
fi;

