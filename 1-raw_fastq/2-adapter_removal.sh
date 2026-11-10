#!/bin/bash
#SBATCH --partition=short
#SBATCH --output=adapter_rm_%A_%a.out
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

set -euo pipefail

SAMPLE_LIST=$1
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST" | tr -d '\r')

AdapterRemoval --file1 ./${NAME}_R1.fastq.gz --file2 ./${NAME}_R2.fastq.gz --basename ${NAME}"_adRem" --outputcollapsed ${NAME}"_collapsed.fastq.gz" --trimns --trimqualities --gzip --mm 3 --minlength 25 --collapse 
