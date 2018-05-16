export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH'

conda create --yes -n khmer-env khmer


conda create --yes -n jellyfish-env jellyfish

conda create --yes -n sourmash-env python=3.6.4
source activate sourmash-env
# Install latest develompent version
pip install https://github.com/dib-lab/sourmash/archive/master.zip


conda create --yes -n mash-env mash


conda info -a


## Show available environments upon login
echo "conda env list" >> ~/.bashrc
source ~/.bashrc
