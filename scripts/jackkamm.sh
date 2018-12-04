#!/bin/bash -x

# download and install miniconda
wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b

echo 'export PATH=$HOME/miniconda3/bin:$PATH' >> ~/.bashrc

# install latest R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo su -c  'echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list'
yes | sudo apt-get update
yes | sudo apt-get install r-base r-base-dev

# install conda
export PATH=$HOME/miniconda3/bin:$PATH
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# install docker
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker ubuntu

# install dotfiles

yes | sudo apt-get install stow htop

git clone https://github.com/jackkamm/dotfiles $HOME/dotfiles
stow -R -t ~ -d $HOME/dotfiles/stow common
