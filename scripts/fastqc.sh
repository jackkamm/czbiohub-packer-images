#!/bin/bash

export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' >> ~/.bashrc # add to bashrc for future use

conda install --yes fastqc

# display info
conda info -a

exit 0
