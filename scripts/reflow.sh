#!/bin/bash -x

# Remove locks on installing packages.
# Ubuntu's unattended-upgrades is at fault here because it's constantly
# monitoring for package upgrades
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
# while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 1 done


# Install latest version of go
echo "Install latest version of go"
sudo add-apt-repository ppa:gophers/archive
sudo apt-get update
sudo apt-get install --allow-unauthenticated --yes golang-1.10-go

# Add go to path
export PATH=/usr/lib/go-1.10/bin:$PATH
echo "export PATH=/usr/lib/go-1.10/bin:$PATH" >> ~/.bashrc

# Create a home for go packages
mkdir $HOME/gocode

# Set home for go packages
export GOPATH=$HOME/gocode
echo "export GOPATH=$HOME/gocode" >> ~/.bashrc

# Make sure go binaries are in path
export PATH=$PATH:$GOPATH/bin
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc

# Tell Reflow to load AWS credentials the way Aegea stores them
export AWS_SDK_LOAD_CONFIG=1
echo "AWS_SDK_LOAD_CONFIG=1" >> ~/.bashrc

echo "Get and install reflow package"
# Add reflow package
go get github.com/grailbio/reflow

# Install reflow binary
go install github.com/grailbio/reflow/cmd/reflow

# test reflow command
reflow -help

sudo cp /tmp/common-session /etc/pam.d/common-session
sudo cp /tmp/common-session-noninteractive /etc/pam.d/common-session-noninteractive
sudo cp /tmp/limits.conf /etc/security/limits.conf
sudo cp /tmp/user.conf /etc/systemd/user.conf

# Send reflow setup commands to bashrc so they get set up for every user's AWS credentials
echo "AWS_SDK_LOAD_CONFIG=1 reflow setup-ec2" >> ~/.bashrc
echo "AWS_SDK_LOAD_CONFIG=1 reflow setup-s3-repository czbiohub-reflow-quickstart-cache" >> ~/.bashrc
echo "AWS_SDK_LOAD_CONFIG=1 reflow setup-dynamodb-assoc czbiohub-reflow-quickstart" >> ~/.bashrc

source ~/.bashrc

exit 0
