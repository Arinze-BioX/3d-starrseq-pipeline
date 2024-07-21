#! /bin/bash
source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate snakemake_HiCAR

snakemake -p -s HiCARTools --forceall --rulegraph | dot -Tpdf > dag.pdf