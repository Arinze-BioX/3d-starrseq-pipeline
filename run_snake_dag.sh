#! /bin/bash
source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate snakemake_3dstarrseq

snakemake -p -s 3dstarrpipe --forceall --rulegraph | dot -Tpng > dag.png