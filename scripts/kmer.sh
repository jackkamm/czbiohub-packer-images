export PATH=$HOME/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH'

# Khmer: khmer.readthedocs.io
conda create --yes -n khmer-env khmer

# Jellyfish: http://www.cbcb.umd.edu/software/jellyfish/
conda create --yes -n jellyfish-env jellyfish

# Sourmash: http://sourmash.readthedocs.io/en/latest/
conda create --yes -n sourmash-env python=3.6.4
source activate sourmash-env
# Install latest develompent version
pip install https://github.com/dib-lab/sourmash/archive/master.zip

# Kraken: http://ccb.jhu.edu/software/kraken/
conda create --yes -n kraken-env kraken

# MASH: http://mash.readthedocs.io/en/latest/
conda create --yes -n mash-env mash


conda info -a


## Show available environments upon login
echo "conda env list" >> ~/.bashrc
source ~/.bashrc
