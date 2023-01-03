#!/bin/bash
#
# Shell script for setting my terminal environment
#
# - Author: Jongkuk Lim
# - Contact: lim.jeikei@gmail.com
# - Github: @jeikeilim

# Bash 3 does not support hash dictionary.
# hput and hget are alternative workaround.
# Usage)
# hput $VAR_NAME $KEY $VALUE
hput() {
    eval "$1""$2"='$3'
}

# Usage)
# `hget $VAR_NAME $KEY`
hget() {
    eval echo '${'"$1$2"'#hash}'
}

hput ARGS "arch" $(uname -m)
hput ARGS "os" $(uname -a | cut -d' ' -f1)
hput ARGS "vim" "nvim"

if [ $# -ne 0 ]; then
    while [ $# -gt 0 ]
    do
        hput ARGS "$(echo $1 | cut -c 2-)" "$2"

        shift 2
        if [ $# -eq 1 ]; then
            echo 'Wrong usage. Arguments must be sets of `-option value` ...'
            break
        fi
    done
fi
# ----------- SETUP ARGS END -------------

OS=$(hget ARGS 'os')
ARCH=$(hget ARGS 'arch')
VIM=$(hget ARGS 'vim')

echo "Setting on $OS-$ARCH ..."

if [ $OS == 'Linux' ]; then  # Linux-x86_64
    sudo apt -y install software-properties-common unzip build-essential tmux htop git
elif [ $OS == 'Darwin' ]; then  # Darwin-arm64
    brew install tmux htop
fi

if [ -d "$HOME/.tmux" ]; then
    echo "Tmux setting already exist. Skip clone tmux setting."
else
    git clone https://github.com/JeiKeiLim/.tmux.git ~/.tmux
    ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
fi

cat >> ~/.inputrc <<'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF

echo "bind -f  ~/.inputrc" >> ~/.bashrc

if [ $VIM == "nvim" ]; then
    echo "Install neovim ..."

    # Install neovim
    if [ $OS == 'Linux' ]; then  # Linux-x86_64-Neovim
        wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
        sudo dpkg -i nvim-linux64.deb
        rm nvim-linux64.deb

        curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
        sudo bash nodesource_setup.sh
        sudo apt-get install -y nodejs ripgrep python3.8-venv
        rm nodesource_setup.sh
    elif [ $OS == 'Darwin' ]; then  # Darwin-arm64-Neovim
        brew install neovim
        brew install node@16 ripgrep shellcheck
    fi

    sudo npm install -g neovim
    git clone -b custom https://github.com/JeiKeiLim/NvChad.git ~/.config/nvim --depth 1
elif [ $VIM == 'vim' ]; then  # Linux-x86_64-Vim
    echo "Install vim ..."
    if [ $OS == 'Linux' ]; then
        sudo add-apt-repository -y ppa:jonathonf/vim
        sudo apt update
        sudo apt -y install vim
    elif [ $OS == 'Darwin' ]; then  # Darwin-arm64-Neovim
        brew install vim
    fi

    cd ~ && git clone --depth=1 https://github.com/JeiKeiLim/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    echo "Install vim ..."
fi

