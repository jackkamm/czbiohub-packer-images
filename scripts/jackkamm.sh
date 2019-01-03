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
# needed by RCurl/bioconductor packages
sudo apt-get install -y libcurl4-openssl-dev

# install docker
# TODO: follow recommended docker installation, instead of using ubuntu packages
# (e.g., there is a bug with "docker push" when ubuntu docker-compose package is installed)
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker ubuntu

# install dotfiles
yes | sudo apt-get install stow htop
git clone https://github.com/jackkamm/dotfiles $HOME/dotfiles
stow -R -t ~ -d $HOME/dotfiles/stow common
