#!/bin/bash -x

# Remove locks on installing packages
sudo rm /var/lib/dpkg/lock

# Install latest version of go
echo "Install latest version of go"
sudo add-apt-repository ppa:gophers/archive
sudo apt-get update
sudo apt-get install --yes golang-1.10-go

# Add go to path
export PATH=/usr/lib/go-1.10/bin:$PATH
echo "export PATH=/usr/lib/go-1.10/bin:$PATH" >> ~/.bashrc

# Set home for go packages
export GOPATH=$HOME/gocode
echo "export GOPATH=$HOME/gocode" >> ~/.bashrc

# Make sure go binaries are in path
export PATH=$PATH:$GOPATH/bin
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc

echo "Get and install reflow package"
# Add reflow package
go get github.com/grailbio/reflow

# Install reflow binary
go install github.com/grailbio/reflow/cmd/reflow

# test reflow command
reflow

# Send reflow setup commands to bashrc so they get set up for every user's AWS credentials
echo "reflow setup-ec2" >> ~/.bashrc
echo "reflow setup-s3-repository" >> ~/.bashrc
echo "reflow setup-dynamodb-assoc" >> ~/.bashrc

exit 0
