#!/bin/bash

# sleep until the instance is ready
for try in {1..100}; do
    if [[ $try -gt 1 ]]
    then
        echo "sleeping 10 sec"
        sleep 10
    fi
    sudo dpkg --configure -a || continue
    break
done

# install updates and upgrades
yes | sudo apt-get -f install
yes | sudo apt-get update

# appears to be necessary to prevent an interactive hang problem
sudo ucf --purge /boot/grub/menu.lst
export DEBIAN_FRONTEND=noninteractive
sudo UCF_FORCE_CONFFNEW=YES apt-get upgrade -yq

# install make, g++, awscli
yes | sudo apt-get install make
yes | sudo apt-get install g++
# this installs packages to system python3 but that's okay
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install awscli

exit 0
