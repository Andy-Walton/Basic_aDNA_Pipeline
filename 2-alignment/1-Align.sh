#!/bin/bash
#SBATCH --partition=medium
#SBATCH --output=alignment_%A_%a.out
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=16
#SBATCH --array=1-3

set -euo pipefail

SAMPLE_LIST=$1
REF=$2

# Family name for this array task
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_LIST}")

bwa aln \
	-t 16 \
	-l 1024 \
	-q 10 \
	../References/$REF ../1-raw_fastq/${NAME}_collapsed.fastq.gz > ${NAME}.sai
echo "------------------------------ mapping done ------------------------------"

bwa samse ../References/$REF  ${NAME}.sai ../1-raw_fastq/${NAME}_collapsed.fastq.gz > ${NAME}.sam
echo "sai to sam done"

rm -f ${NAME}.sai

echo "------------------------------ Done, took $((SECONDS / 60)) minutes and $((SECONDS % 60)) seconds. ------------------------------"
