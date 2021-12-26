mkdir -p "$HOME/.config"
mkdir -p "$HOME/.doom.d"

stow --target "$HOME" bashrc
stow --target "$HOME/.doom.d" --no-folding .doom.d
stow --target "$HOME" gitconfig
stow --target "$HOME" gtk
stow --target "$HOME" tmux
stow --target "$HOME" xserver
stow --target "$HOME" zsh
stow --target "$HOME/.config" alacritty
stow --target "$HOME/.config" chrome/
stow --target "$HOME/.config" flake8/
stow --target "$HOME/.config" gtkconfig
stow --target "$HOME/.config" --no-folding pulseaudio
stow --target "$HOME/.config" ranger
stow --target "$HOME/.config" rofi
stow --target "$HOME/.config" rofi-pass
stow --target "$HOME/.config" systemd
stow --target "$HOME/.config" wallpaper


