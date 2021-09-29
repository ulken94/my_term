#!/bin/bash

sudo apt -y install software-properties-common

sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt update
sudo apt -y install tmux vim htop

cd ~
git clone --depth=1 https://github.com/JeiKeiLim/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

git clone https://github.com/JeiKeiLim/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

cat >> ~/.inputrc <<'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF

echo "bind -f  ~/.inputrc" >> ~/.bashrc

