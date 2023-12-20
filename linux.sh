#!/usr/bin/env bash

ok=0
option=""

if [ $# -gt 0 ]; then
	option=$1
fi

if [ "$option" = "install" ]; then
	ok=1

	# required
	mv ~/.config/nvim{,.bak}

	# optional but recommended
	mv ~/.local/share/nvim{,.bak}
	mv ~/.local/state/nvim{,.bak}
	mv ~/.cache/nvim{,.bak}

	# Clone the starter
	git clone https://github.com/LazyVim/starter ~/.config/nvim

	# Remove the .git folder, so you can add it to your own repo later
	rm -rf ~/.config/nvim/.git ~/.config/nvim/.gitignore

	# Copy my lazyvim settings
	cp -r ./lua ~/.config/nvim

	#Start Neovim!
	nvim
elif [ "$option" = "config" ]; then
	ok=1

	# Copy my lazyvim settings
	cp -r ./lua ~/.config/nvim
fi

if [ $ok -eq 0 ]; then
	echo "USAGE: $0 [install|config]"
	echo "1) install: install LazyVim starter template & set my configuration"
	echo "2) config: only set my configuration without installation of LazyVim starter template"
	exit 1
fi
