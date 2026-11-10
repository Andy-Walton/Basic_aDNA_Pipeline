#!/bin/bash
#SBATCH --partition=medium
#SBATCH --output=QualiMap_%A_%a.out
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=1

set -euo pipefail

SAMPLE_LIST=$1
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_LIST}")

/mnt/apps/users/awalton/conda/bin/conda run \
    --no-capture-output \
    -n fastqc_env \
    qualimap bamqc \
        -bam "./${NAME}_final.bam" \
        -outdir "./Qualimap_reports/${NAME}_report"

echo "--------------- Qualimap done. ---------------"
