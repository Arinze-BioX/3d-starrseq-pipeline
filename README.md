# HiCARTools
This is the HiCAR datasets processing  pipeline for Diao lab. The pipeline is still in the development stage, please let us know of any bugs and how to improve!

# work flow of the pipeline

![](./workflow.svg)


# Dependencies 
HiCARTools requires following programs and packages. Install them prior to using HiCARTools. HiCARTools runs on Linux.
* python3 
* snakemake (workflow management)
* cutadaptor
* BWA 
* samtools 
* pairstool
* pairix
* cooltools
* macs2


# Installation
Install the snakemake first via conda. The default conda solver is a bit slow and sometimes has issues with selecting the latest package releases. Therefore, It is recommend to install Mamba as a drop-in replacement via
`$ conda install -c conda-forge mamba`
`$ mamba install -c bioconda -c conda-forge snakemake-minimal`
Makesure you have other programs installed before buy 



# How to run it.
1. Remember to install before running anything (see INSTALL).
2. Create your project folder. 
3. Inside your project folder, create a folder named `fastq`, and put all your .fastq files in that folder.  
...


# Output formats: 
##  Pairs: 
```
Columns: 
=======
1)Read Name 
2) R1 mapping Flag
3) R1 chr 
4) R1 position 
5) R1 fragment 
6) R2 mapping Flag
7) R2 chr 
8) R2 position 
9) R2 fragment 
10) R1 mapping quality
11) R2 mapping quality
```

# Contributing Authors

