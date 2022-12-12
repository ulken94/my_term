#!/bin/bash

sudo apt -y install software-properties-common

# Install neovim
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
sudo dpkg -i nvim-linux64.deb
rm nvim-linux64.deb

curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install nodejs
rm nodesource_setup.sh
sudo npm install -g neovim

git clone -b custom https://github.com/JeiKeiLim/NvChad.git ~/.config/nvim --depth 1
sudo apt install -y unzip build-essential python3.8-venv tmux htop

git clone https://github.com/JeiKeiLim/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

cat >> ~/.inputrc <<'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF

echo "bind -f  ~/.inputrc" >> ~/.bashrc

