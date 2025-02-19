This is my lazyvim settings.  
(based on LazyVim's starter template)

```bash
# Neovim
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_INSTALL_PREFIX=$HOME/.local install
make CMAKE_BUILD_TYPE=Release
cd -

# Pyenv / python / pip
curl -fsSL https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
source ~/.bashrc
sudo apt install libbz2-dev
pyenv install 3.12.9
pyenv global 3.12.9  # under user home
pip install --upgrade pip

# Nodejs / npm
git clone https://github.com/nodejs/node
cd node
# git switch v18.x # if g++ is too old
./configure
make
make install PREFIX=$HOME/.local
cd -
```
