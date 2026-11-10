#!/bin/bash
#SBATCH --partition=medium
#SBATCH --output=Process_BAMs_%A_%a.out
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-3

set -euo pipefail

SAMPLE_LIST=$1
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_LIST}")

QUAL=30

samtools view -Sb ${NAME}.sam > ${NAME}.new.temp.bam
echo "sam to bam complete"
samtools sort ${NAME}.new.temp.bam -o ${NAME}_sort.temp.bam -O BAM
echo "sort complete"
samtools view -b -q ${QUAL} ${NAME}_sort.temp.bam > ${NAME}_q${QUAL}.temp.bam
echo "qc complete"
samtools markdup -r ${NAME}_q${QUAL}.temp.bam ${NAME}_duprem_q30.temp.bam
echo "markdup complete"
samtools view -F 4 -b ${NAME}_duprem_q30.temp.bam > ${NAME}_final.bam
echo "unaligned removed"

rm -f "${NAME}.new.temp.bam"
rm -f "${NAME}_sort.temp.bam"
rm -f "${NAME}_q${QUAL}.temp.bam"
rm -f "${NAME}_duprem_q${QUAL}.temp.bam"
rm -f "${NAME}.sam"

echo "------------------------------ Done, took $((SECONDS / 60)) minutes and $((SECONDS % 60)) seconds. ------------------------------"
