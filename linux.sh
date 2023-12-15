#!/usr/bin/env bash

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
