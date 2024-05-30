#!/usr/bin/env bash

ok=1
option=""

if [ $# -gt 0 ]; then
	option=$1
fi

function move_dir_to_bak() {
	[ -f "$1.bak" ] && rm -rf "$1.bak"
	[ -d "$1.bak" ] && rm -rf "$1.bak"
	[ -d "$1" ] && mv "$1" "$1.bak"
}

if [ "$option" = "install" ]; then
	move_dir_to_bak "$HOME/.config/nvim"
	move_dir_to_bak "$HOME/.local/share/nvim"
	move_dir_to_bak "$HOME/.local/state/nvim"
	move_dir_to_bak "$HOME/.cache/nvim"

	# Clone the starter
	git clone https://github.com/LazyVim/starter ~/.config/nvim

	# Remove the .git folder, so you can add it to your own repo later
	rm -rf ~/.config/nvim/.git ~/.config/nvim/.gitignore ~/.config/nvim/lua

	# Copy my lazyvim settings
	cp -r ./lua ~/.config/nvim

	#Start Neovim!
	nvim
elif [ "$option" = "config" ]; then
	# Copy my lazyvim settings
	cp -r ./lua ~/.config/nvim
elif [ "$option" = "clean" ]; then
	rm -rf ~/.config/nvim/*

	rm -rf ~/.local/share/nvim/*
	rm -rf ~/.local/state/nvim/*
	rm -rf ~/.cache/nvim/*
else
	ok=0
fi

if [ $ok -eq 0 ]; then
	echo "USAGE: $0 [install|config]"
	echo "1) install: install LazyVim starter template & set my configuration"
	echo "2) config: only set my configuration without installation of LazyVim starter template"
	exit 1
fi
