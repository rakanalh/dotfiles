install: install-zsh install-bash install-pythonrc install-bin install-git install-emacs install-tmux

install-git:
	ln -fs `pwd`/git/gitconfig ~/.gitconfig
	curl -o ~/.git-completion.bash https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -OL

install-bin:
	mkdir -p ~/.bin/
	ln -fs `pwd`/bin/* ~/.bin/

install-bash:
	ln -fs `pwd`/bash/bashrc ~/.bash_profile
	ln -fs ~/.bash_profile ~/.bashrc
	@echo "Old .bash_profile saved as .bash_profile.old"

install-tmux:
	ln -fs `pwd`/tmux/tmux.conf ~/.tmux.conf

install-pythonrc:
	ln -fs `pwd`/python/pythonrc.py ~/.pythonrc.py

install-zsh:
	# Install Oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	ln -fs `pwd`/zsh/zshrc ~/.zshrc
	curl -o ~/.oh-my-zsh/themes/dracula.zsh-theme https://raw.githubusercontent.com/dracula/zsh/master/dracula.zsh-theme -OL
	git clone -q git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions || true

install-emacs:
	mkdir -p ~/.emacs.d
	git clone -q git://github.com/rakanalh/dotemacs ~/.emacs.d/ || true
