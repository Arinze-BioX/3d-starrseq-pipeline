#! /bin/bash

source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate snakemake_3dstarrseq

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
filename="trial_${timestamp}.log"

snakemake -p --snakefile 3dstarrpipe --profile myprofile --rerun-incomplete --resources cpu=1 \
--jobs 99 --keep-going 2> "${filename}"