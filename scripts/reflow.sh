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

# Get release version of reflow
wget https://github.com/grailbio/reflow/releases/download/reflow0.6.8/reflow0.6.8.linux.amd64
sudo cp reflow0.6.3.linux.amd64 /usr/local/bin/reflow
sudo chmod ugo+x /usr/local/bin/reflow

# echo "Installing AWS dependencies"
# go get github.com/aws/aws-sdk-go
# go get github.com/cihub/seelog
# go get github.com/pkg/errors
#
# echo "Get and install reflow package"
# # Add reflow package
# go get github.com/grailbio/reflow
#
# # Install reflow binary
# go install github.com/grailbio/reflow/cmd/reflow

# test reflow command
reflow -help

# These files are necessary to increase the number of open file limits
# so reflow can run on 1000s of files at once
sudo cp /tmp/common-session /etc/pam.d/common-session
sudo cp /tmp/common-session-noninteractive /etc/pam.d/common-session-noninteractive
sudo cp /tmp/limits.conf /etc/security/limits.conf

# Normally the previous 3 lines would work but there's been a bug in Ubuntu
# since 16.00: https://bugs.launchpad.net/ubuntu/+source/pam/+bug/65244
# This stackoverflow answer has the correct information:
# https://superuser.com/a/1200818/166053
sudo cp /tmp/user.conf /etc/systemd/user.conf
sudo cp /tmp/system.conf /etc/systemd/system.conf

# Send reflow setup commands to bashrc so they get set up for every user's AWS credentials
echo "AWS_SDK_LOAD_CONFIG=1 reflow setup-ec2" >> ~/.bashrc
echo "AWS_SDK_LOAD_CONFIG=1 reflow setup-dynamodb-assoc czbiohub-reflow-quickstart" >> ~/.bashrc
echo "echo 'repository: s3,czbiohub-reflow-quickstart-cache' >> ~/.reflow/config.yaml" >> ~/.bashrc

source ~/.bashrc

exit 0
