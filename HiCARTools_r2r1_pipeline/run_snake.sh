#! /bin/bash
source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate snakemake_3dstarrseq

snakemake -p --snakefile HiCARTools --profile myprofile --rerun-incomplete \
--default-resources mem="30G" --jobs 99