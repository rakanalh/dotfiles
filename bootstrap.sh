/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

brew tap caskroom/cask

brew cask install google-chrome google-drive slack skype alfred iterm2 virtualbox vagrant karabiner-elements hammerspoon istat-menus vmware-fusion dropbox keepassx java
brew install tmux coreutils automake zsh-syntax-highlighting zsh-autosuggestions jq ag awscli
brew install pyenv pyenv-virtualenv golang gradle

sudo easy_install pip
sudo pip install tmuxp

mkdir ~/Code
mkdir ~/Code/C
mkdir ~/Code/Python
mkdir ~/Code/Elisp

git clone git://github.com/rakanalh/dotfiles.git
cd dotfiles
make install

git clone git://git.savannah.gnu.org/emacs.git ~/Code/C/Emacs

xcode-select --install
brew install readline xz
pyenv install 2.7.12
pyenv install 3.4.5
