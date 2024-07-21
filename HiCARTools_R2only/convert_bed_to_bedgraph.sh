#!/bin/bash
#
#SBATCH --job-name=bed2bg_par
#SBATCH --output=bed2bg_par.out
#SBATCH --error=bed2bg_par.err
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --array=0-5
#SBATCH --mem-per-cpu=30G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=aeo21@duke.edu

PATH1='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2only/macs2_peak-hg38/'
FILES=($(ls ${PATH1}*_atac_pairs.bed |perl -p -e "s/\/.*macs2\_peak-hg38\///g"|perl -p -e "s/\_atac\_pairs.bed//g"))
FILE=${FILES[${SLURM_ARRAY_TASK_ID}]}

source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate bedtools

cat ${PATH1}${FILE}_atac_pairs.bed | uniq | sort -k1,1V -k2,2n | awk 'BEGIN {OFS="\t"} ; { {print $1, $2 - 75, $2 + 75}}' |\
bedtools genomecov -bg -g /datacommons/ydiaolab/genome_ref/hg38_BWA_index/hg38.chrom.sizes -i "stdin" > ${PATH1}${FILE}.bedgraph