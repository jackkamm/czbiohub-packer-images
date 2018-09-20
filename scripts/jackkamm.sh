#!/bin/bash -x

sudo apt-get install stow htop

git clone https://github.com/jackkamm/dotfiles $HOME/dotfiles
stow -R -t ~ -d $HOME/dotfiles/stow common

ln -s /mnt/data $HOME/data

export PATH=$HOME/anaconda/bin:$PATH # add to PATH
conda config --set always_yes no --set changeps1 yes
