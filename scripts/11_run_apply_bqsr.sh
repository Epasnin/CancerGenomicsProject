#!/bin/bash
#SBATCH --job-name=applybqsr
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/pkunjal/cancer_genomics/logs/output_applybqsr_%j.o
#SBATCH --error=/data/users/pkunjal/cancer_genomics/logs/error_applybqsr_%j.e

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11
module load SAMtools   

PROJECTDIR="/data/users/pkunjal/cancer_genomics"
MARKEDBAMDIR="$PROJECTDIR/alignments/marked"
TABLEDIR="$PROJECTDIR/results/alignments/bqsr_tables"
OUTDIR="$PROJECTDIR/results/alignments/recal"

REF="/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    gatk ApplyBQSR \
        -I "$MARKEDBAMDIR/${ID}_marked.bam" \
        -R "$REF" \
        --bqsr-recal-file "$TABLEDIR/${ID}_recal_data.table" \
        -O "$OUTDIR/${ID}.recal.bam"

    samtools index "$OUTDIR/${ID}.recal.bam"
done