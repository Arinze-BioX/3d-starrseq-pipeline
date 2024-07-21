#! /bin/bash
source /datacommons/ydiaolab/arinze/apps/miniconda_20220118/etc/profile.d/conda.sh
conda activate snakemake_HiCAR

snakemake --latency-wait 90 -p -s HiCARTools -j 99 --cluster-config cluster.json --rerun-incomplete \
--cluster "sbatch -J {cluster.job} --mem={cluster.mem} -N 1 -n {threads} -o {cluster.out} -e {cluster.err}"