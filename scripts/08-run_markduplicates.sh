#!/bin/bash
#SBATCH --job-name=mark_duplicates
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/output_mark_duplicates_%j.o
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/error_mark_duplicates_%j.e

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11
module load SAMtools/1.13-GCC-10.3.0

PROJECTDIR="/data/users/epasnin/CancerGenomicsProject"
ALIGNMENTS="$PROJECTDIR/alignments/"
OUTDIR="$ALIGNMENTS/marked"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    INPUT_BAM="$ALIGNMENTS/sorted/${ID}_sorted.bam"
    OUTPUT_BAM="$OUTDIR/${ID}_marked.bam"
    METRICS_FILE="$OUTDIR/${ID}_marked_metrics.txt"

    gatk MarkDuplicates \
        -I "$INPUT_BAM" \
        -O "$OUTPUT_BAM" \
        -M "$METRICS_FILE" 

    samtools index "$OUTPUT_BAM"
done