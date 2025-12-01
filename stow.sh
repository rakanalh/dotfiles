#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Packages to stow (each mirrors $HOME structure)
PACKAGES=(
  shell
  starship
  git
  tmux
  alacritty
  atuin
  zellij
  gh
  gtk
)

echo "Stowing dotfiles from: $DOTFILES_DIR"

# Ensure .config exists
mkdir -p "$HOME/.config"

# Stow each package
for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    echo "  Stowing $pkg..."
    stow -v -t "$HOME" "$pkg"
  else
    echo "  Skipping $pkg (not found)"
  fi
done

# Handle submodules (nvim and doom) - these are full git repos
# that need to be linked directly into .config
echo ""
echo "Linking submodules..."

if [ -d "$DOTFILES_DIR/nvim" ]; then
  if [ -L "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
  elif [ -d "$HOME/.config/nvim" ]; then
    echo "  Warning: ~/.config/nvim exists and is not a symlink. Backing up..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
  fi
  ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  echo "  Linked nvim -> ~/.config/nvim"
fi

if [ -d "$DOTFILES_DIR/doom" ]; then
  if [ -L "$HOME/.config/doom" ]; then
    rm "$HOME/.config/doom"
  elif [ -d "$HOME/.config/doom" ]; then
    echo "  Warning: ~/.config/doom exists and is not a symlink. Backing up..."
    mv "$HOME/.config/doom" "$HOME/.config/doom.backup.$(date +%s)"
  fi
  ln -sfn "$DOTFILES_DIR/doom" "$HOME/.config/doom"
  echo "  Linked doom -> ~/.config/doom"
fi

echo ""
echo "Done! Run 'stow.sh --unstow' to remove symlinks."
