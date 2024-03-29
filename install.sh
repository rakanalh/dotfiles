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
yay -S \
  acpi_call \
  blueman \
  bluez \
  bluez-utils \
  ccid \
  cmake \
  clang \
  dbus-broker \
  htop \
  hopenpgp-tools \
  libfido2 \
  lxappearance \
  mpd \
  mpdris2 \
  ntfs-3g \
  nvidia-settings \
  networkmanager \
  network-manager-applet \
  oh-my-zsh-git \
  openssh \
  pam-u2f \
  pcsclite \
  pinentry \
  pulseaudio-bluetooth \
  rsync\
  udisks2 \
  udiskie \
  vim \
  wget \
  xf86-video-intel

# Install fonts
yay -S \
  ttf-ubuntu-font-family \
  ttf-hack \
  nerd-fonts \
  ttf-font-awesome \
  ttf-ubuntu-arabic \
  noto-fonts-complete\
  ttf-ms-fonts

# Install Apps
yay -S \
  alacritty \
  adwaita-icon-theme \
  arc-gtk-theme \
  arc-icon-theme \
  autojump \
  bat \
  deepin-calculator \
  deepin-camera \
  deepin-screenshot \
  deepin-image-viewer \
  deepin-reader \
  deepin-editor \
  exa \
  element-desktop \
  evince \
  feh \
  file-roller \
  firefox \
  fzf \
  ffmpegthumbnailer \
  gimp \
  gnupg \
  google-chrome \
  gparted
  imagemagick \
  i3lock-fancy \
  libgfs \
  ledger-live-bin \
  mpv \
  openra \
  pcmanfm \
  pavucontrol \
  plex-media-server \
  qtpass \
  ripgrep \
  rofi \
  rofi-pass \
  rofi-calc \
  stow \
  slack-desktop \
  the_silver_searcher \
  telegram-desktop \
  transmission-gtk \
  tmux \
  vlc \
  yubikey-manager \
  yubico-pam \
  yubikey-personalization \
  zoom \
  zsh \
  zsh-syntax-highlighting \
  zsh-autosuggestions 

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

plex_status=$(systemctl is-enabled plexmediaserver.service)
if [ "${plex_status}" != "enabled" ]; then
  sudo systemctl enable plexmediaserver.service
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

xset -dpms
xset s off

# https://wiki.archlinux.org/title/Bluetooth#Auto_power-on_after_boot/resume
# https://wiki.archlinux.org/title/Bluetooth#PulseAudio
# https://wiki.archlinux.org/title/Bluetooth_headset#Setting_up_auto_connection
# https://howto.lintel.in/install-nvidia-arch-linux/
# https://wiki.archlinux.org/title/NVIDIA#DRM_kernel_mode_setting
