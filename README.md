# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
~/.dotfiles/
├── shell/       # zsh, bash configs
├── starship/    # starship prompt
├── git/         # git config
├── tmux/        # tmux config
├── alacritty/   # terminal emulator
├── atuin/       # shell history
├── zellij/      # terminal multiplexer
├── gh/          # GitHub CLI
├── gtk/         # GTK settings
├── nvim/        # Neovim (submodule)
├── doom/        # Doom Emacs (submodule)
└── _archive/    # old configs
```

## Installation

```bash
# Clone with submodules
git clone --recursive git@github.com:rakanalh/dotfiles.git ~/.dotfiles

# Or if already cloned:
git submodule update --init --recursive

# Apply symlinks
cd ~/.dotfiles
./stow.sh
```

## Usage

Each directory is a "stow package" that mirrors the home directory structure.
Running `stow.sh` creates symlinks from `~/.dotfiles/*/` to `~/`.

### Adding a new package

1. Create directory: `mkdir -p package/.config/app`
2. Add config files mirroring home structure
3. Add package name to `PACKAGES` array in `stow.sh`
4. Run `./stow.sh`

### Removing symlinks

```bash
stow -D -t "$HOME" <package>
```
