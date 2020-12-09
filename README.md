# HiCARTools
This is the HiCAR datasets processing  pipeline for Diao lab. The pipeline is followed the [4DN HiC process pipeline](https://data.4dnucleome.org/resources/data-analysis/hi_c-processing-pipeline)  and is still in the development stage, please let us know of any bugs and how to improve!

# work flow of the pipeline
![](./workflow.svg)

# Dependencies 
HiCARTools requires following programs and packages. Please install them prior to using HiCARTools. HiCARTools runs on Linux.
* python 3 version
* [snakemake] 5.28 (https://snakemake.readthedocs.io/en/stable/) (workflow management)
* [cutadaptor] 3.0(https://cutadapt.readthedocs.io/en/stable/)
* [BWA ] 0.7.1(http://bio-bwa.sourceforge.net)
* [samtools ]1.1(http://www.htslib.org/download/)
* [pairstool] 0.3 (https://pairtools.readthedocs.io/en/latest/installation.html)
* [pairix]0.3.7(https://github.com/4dn-dcic/pairix#installation-for-pairix)
* [cooler]0.8 (https://github.com/open2c/cooler)
* [macs2]2.2.7(https://github.com/macs3-project/MACS)


# Installation
Install the snakemake first via conda. The default conda solver is a bit slow and sometimes has issues with selecting the latest package releases. Therefore, It is recommend to install Mamba as a drop-in replacement via 
```
conda install -c conda-forge mamba
mamba install -c bioconda -c conda-forge snakemake-minimal 
```
Install other dependencies and add them to the path.
You will also need the bwa index of your genome, which can be created via `bwa index [ref_genome_fastq_file]`.
The genome restriction fragments file can be created by cooler via
 `cooler digest -o output.bed CHROMSIZES_PATH FASTA_PATH ENZYME`


# How to run the workflow.
1. Obtain a copy of this workflow. `git clone https://github.com/diao-lab/HiCARTools.git`
2. Inside `HiCARTools`folder, create a folder named `fastq`, and put all your .fastq files in that folder. 
3. create sample information meta file in the json formate.
e.g. 
```
{
    "sample1": {
        "R1": [
            "fastq/sample1_L001_R1_001.fq.gz"
        ],
        "R2": [
            "fastq/sample1_L001_R2_001.fq.gz"
        ]
    }
}
```
4. update the path to bwa index and restriction fragments files in the config.yaml file.
5. run the snakemake workflow via `snakemake  -p -s HiCARTools -j [NO.of.CPU]`
6. you can also run the job on HPC cluster scheduler. example for the SLURM system.
```
snakemake --latency-wait 90 -p -s HiCARTools -j 99 --cluster-config cluster.json \
--cluster "sbatch -J {cluster.job} --mem={cluster.mem} -N 1 -n {threads} -o {cluster.out} -e {cluster.err}
```

# Output files: 
###  [pairs](https://pairtools.readthedocs.io/en/latest/formats.html) containing a list of valid contacts.
```
Columns: 
=======
1) Read Name 
2) chr1
3) pos1
4) chr2
5) pos2
6) strand1
7) strand1
```
### [cooler](https://cooler.readthedocs.io/en/latest/datamodel.html), genomically-labeled sparse 2D matrices, which can be viewed by [HiGlass](https://docs.higlass.io)
### ATAC peaks called by macs2.



