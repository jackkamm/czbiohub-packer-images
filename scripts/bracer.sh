conda install --yes -c bioconda bowtie2 trinity igblast blast kallisto graphviz phylip trim-galore

## Keep running out of room when installing anaconda stuff
mv ~/anaconda /mnt/data
ln -s /mnt/data/anaconda ~/


# Conda install requirements
conda install -c bioconda --yes python=3.6 biopython matplotlib networkx=1.11 cycler numpy pandas pyparsing pytz scipy seaborn six mock future  cutadapt

cd /mnt/data
git clone https://github.com/Teichlab/bracer
cd bracer
pip install .


cd /mnt/data
aws s3 sync s3://olgabot-genomes genome

cat "#Configuration file for BraCeR#

[tool_locations]
#paths to tools used by BraCeR for alignment, quantitation, etc
#bowtie2_path = /path/to/bowtie2
#igblastn_path = /path/to/igblastn
#blastn_path = /path/to/blastn
#kallisto_path = /path/to/kallisto
#trinity_path = /path/to/Trinity
#dot_path = /path/to/dot
#neato_path = /path/to/neato
#changeo_path = /path/to/directory_containing_changeo_scripts
#rscript_path = /path/to/Rscript
#dnapars_path = /path/to/dnapars
#trim_galore_path = /path/to/trim_galore
#cutadapt_path = /path/to/cutadapt

[trinity_options]
#line below specifies maximum memory for Trinity Jellyfish component. Set it appropriately for your environment.
max_jellyfish_memory = 60G

[kallisto_transcriptomes]
Hsap = /mnt/data/genome/hg38/gencode/v28/gencode.v28.transcripts.fa
Mmus = /mnt/data/genome/mm10/gencode/m17/gencode.vM17.transcripts.fa

[bracer_location]
#Path to where BraCeR was originally installed
bracer_path = /mnt/data/bracer" > ~/.bracerrc

bracer test -p 16 -c ~/.bracerrc