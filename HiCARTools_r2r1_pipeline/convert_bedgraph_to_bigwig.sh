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

PATH1='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2R1/peaks-hg38/'
PATH2='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2R1/bigwigs/'
PATH3='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2R1/macs2_peak/'
FILES=($(ls ${PATH1}*.R2.ATAC.bed.gz|perl -p -e "s/\/.*peaks-hg38\///g"|perl -p -e "s/\.R2\.ATAC\.bed\.gz//g"))
FILE=${FILES[${SLURM_ARRAY_TASK_ID}]}

/datacommons/ydiaolab/arinze/ThreeD_STARRseq/bedGraphToBigWig ${PATH1}${FILE}.bedgraph \
/datacommons/ydiaolab/genome_ref/hg38_BWA_index/hg38.chrom.sizes ${PATH2}${FILE}.bw
/datacommons/ydiaolab/arinze/ThreeD_STARRseq/bedGraphToBigWig ${PATH3}${FILE}_hg38_treat_pileup.bdg \
/datacommons/ydiaolab/genome_ref/hg38_BWA_index/hg38.chrom.sizes ${PATH2}${FILE}_macs2_.bw
