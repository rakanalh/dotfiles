#!/usr/bin/env bash
set -e

# Set timezone
timedatectl set-timezone Asia/Amman
sudo ln -sf /usr/share/zoneinfo/Asia/Amman /etc/localtime

# Install yay
if ! command -v yay &> /dev/null; then
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay-bin.git ~/Downloads/yay-bin && cd ~/Downloads/yay-bin && makepkg -si
  cd -
fi

yay -Syu

yay --save --answerclean All --answerdiff All
yay --save --nocleanmenu --nodiffmenu

# Install System Dependencies
yay -S wget vim blueman bluez bluez-utils udisks2 udiskie dbus-broker zsh oh-my-zsh-git ntfs-3g openssh yubikey-manager yubico-pam pam-u2f libfido2 pcsclite ccid hopenpgp-tools yubikey-personalization pinentry zsh zsh-syntax-highlighting zsh-autosuggestions autojump xf86-video-intel lxappearance adwaita-icon-theme htop pulseaudio-bluetooth acpi_call nvidia-settings rsync

# Install fonts
yay -S ttf-ubuntu-font-family ttf-hack nerd-fonts ttf-font-awesome ttf-ubuntu-arabic noto-fonts ttf-ms-fonts

# Install Apps
yay -S alacritty pcmanfm gnupg stow rofi rofi-pass rofi-calc firefox nerd-fonts-complete element-desktop telegram-desktop slack zoom google-chrome ledger-live-bin tmux bat fzf exa arc-gtk-theme arc-icon-theme i3lock-fancy pavucontrol deepin-calculator deepin-screenshot transmission-gtk

# Install Python
yay -S python39 python-virtualenv libffi libsrtp

# Clone dotfiles
if [ ! -d "~/.dotfiles" ]; then
  git clone git@github.com:rakanalh/dotfiles.git ~/.dotfiles
  ./stow-dot-files.sh
fi

if [ ! -d "~/.config/awesome" ]; then
  git clone git@github.com:rakanalh/awesome-config.git ~/.config/awesome
fi

# Clone passwords
if [ ! -d "~/.password-store" ]; then
  git clone git@github.com:rakanalh/store.git ~/.password-store
fi

# Firefox
./install-firefox-profile.sh

# Tmux and Tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Ledger live
wget -q -O - https://www.ledgerwallet.com/support/add_udev_rules.sh | sudo bash
sudo usermod -a -G plugdev rakan

# Services
bluetooth_status=$(systemctl is-enabled bluetooth.service)
if [ "${bluetooth_status}" != "enabled" ]; then
  sudo systemctl enable bluetooth.service
fi

dbusbroker_status=$(systemctl is-enabled dbus-broker.service)
if [ "${dbusbroker_status}" != "enabled" ]; then
  sudo systemctl enable dbus-broker.service
fi

# Other
if [ ! -f "/usr/bin/vi" ]; then
  sudo ln -s /usr/bin/vim /usr/bin/vi
fi

# Use zsh
chsh -s /usr/bin/zsh rakan
sudo cp .dotfiles/zsh/iGeek.zsh-theme /usr/share/oh-my-zsh/themes/

# Install Emacs
if ! command -v emacs &> /dev/null; then
  yay -S emacs28-git
  git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
  ~/.emacs.d/bin/doom install
fi

# Install Rust
if ! command -v rustup &> /dev/null; then
  yay -S rustup rust-analyzer-git
  rustup toolchain install stable
  rustup toolchain install nightly
  rustup component add rustfmt clippy
  rustup component add rustfmt clippy --toolchain nightly
  rustup target add wasm32-unknown-unknown
  rustup target add wasm32-unknown-unknown --toolchain nightly
  cargo install cargo-remote
fi

# https://wiki.archlinux.org/title/Bluetooth#Auto_power-on_after_boot/resume
# https://wiki.archlinux.org/title/Bluetooth#PulseAudio
# https://wiki.archlinux.org/title/Bluetooth_headset#Setting_up_auto_connection
# https://howto.lintel.in/install-nvidia-arch-linux/
# https://wiki.archlinux.org/title/NVIDIA#DRM_kernel_mode_setting
