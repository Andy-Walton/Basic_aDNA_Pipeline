#!/bin/bash
#SBATCH --partition=short
#SBATCH --output=raw_fastqc_%A_%a.out
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2

set -euo pipefail

SAMPLE_LIST=$1
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST" | tr -d '\r')

# run the call to FastQC, putting outputs into 
fastqc -t 2 ${NAME}"_R1.fastq.gz" --outdir=./

fastqc -t 2 ${NAME}"_R2.fastq.gz" --outdir=./
