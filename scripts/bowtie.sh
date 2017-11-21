#!/bin/bash
echo "sleeping 30 sec"; sleep 30
for try in {1..100}; do if [[ $try -gt 1 ]]; then echo "sleeping 10 sec"; sleep 10; fi; sudo dpkg --configure -a || continue; break; done
sudo apt-get -f install
yes | sudo apt-get install make
yes | sudo apt-get install g++
yes | sudo apt-get install libz-dev
yes | sudo apt-get install libtbb-dev

wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.3.1/bowtie2-2.3.3.1-source.zip
unzip bowtie2-2.3.3.1-source.zip
cd bowtie2-2.3.3.1/
make

echo "done building, moving binaries"
mkdir $HOME/bin
cp bowtie2{,-align-s,-align-l,-build,-build-s,-build-l,-inspect,-inspect-s,-inspect-l} $HOME/bin/
cd $HOME

echo "removing source directory"
rm bowtie2-2.3.3.1-source.zip
rm -rf bowtie2-2.3.3.1
echo "finished"

exit 0
