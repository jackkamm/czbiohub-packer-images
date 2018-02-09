#!/bin/bash -x

# format the volume and mount it
lsblk
sudo file -s /dev/xvde
sudo mkfs -t ext4 /dev/xvde
sudo mkdir /mnt/data
sudo mount /dev/xvde /mnt/data
sudo chown `whoami` /mnt/data

# get UUID and add to fstab
uuid=`lsblk /dev/xvde -no UUID`
echo "UUID=${uuid}  /mnt/data  ext4  defaults,nofail  0  2" | sudo tee -a /etc/fstab
