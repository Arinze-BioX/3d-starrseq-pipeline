#!/bin/bash
#
#SBATCH --job-name=bed2pe
#SBATCH --output=bed2pe.out
#SBATCH --error=bed2pe.err
#SBATCH --cpus-per-task=1
#SBATCH --partition=scavenger
#SBATCH --time=24:00:00
#SBATCH --array=0-5
#SBATCH --mem-per-cpu=30G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=aeo21@duke.edu

PATH1='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2R1/final_bed-hg38/'
PATH2='/datacommons/ydiaolab/arinze/ThreeD_STARRseq/combined_DNA_eGFP_Nov2023/HiCARTools_new_R2R1/bed_for_rep/'
FILES=($(ls ${PATH1}*.bed|perl -p -e "s/\/.*final_bed-hg38\///g"|perl -p -e "s/\.bed//g"))
FILE=${FILES[${SLURM_ARRAY_TASK_ID}]}
echo ${FILE}

awk '{{ print $1"\t"$2"\t"$3"\t"$7"\t"$8"\t"$9"\n"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$10 }}' ${PATH1}${FILE}.bed > ${PATH2}${FILE}.bed