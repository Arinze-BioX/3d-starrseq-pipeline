#!/bin/bash
#
#SBATCH --job-name=bdg2bw_par
#SBATCH --output=bdg2bw_par.out
#SBATCH --error=bdg2bw_par.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --array=0-5
#SBATCH --mem-per-cpu=20G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=aeo21@duke.edu

PATH1='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2only/macs2_peak-hg38/'
PATH2='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2only/bigwigs/'
FILES=($(ls ${PATH1}*_atac_pairs.bed |perl -p -e "s/\/.*macs2\_peak-hg38\///g"|perl -p -e "s/\_atac\_pairs.bed//g"))
FILE=${FILES[${SLURM_ARRAY_TASK_ID}]}

/datacommons/ydiaolab/arinze/ThreeD_STARRseq/bedGraphToBigWig ${PATH1}${FILE}.bedgraph \
/datacommons/ydiaolab/genome_ref/hg38_BWA_index/hg38.chrom.sizes ${PATH2}${FILE}.bw