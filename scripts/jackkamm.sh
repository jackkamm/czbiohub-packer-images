#!/bin/bash -x

git clone https://github.com/jackkamm/dotfiles $HOME/dotfiles
sudo apt-get install stow
stow -R -t ~ -d $HOME/dotfiles/stow common

ln -s /mnt/data $HOME/data

export PATH=$HOME/anaconda/bin:$PATH # add to PATH
conda config --set always_yes no --set changeps1 yes
