#!/bin/bash
#SBATCH --job-name=baserecal
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/pkunjal/cancer_genomics/logs/output_baserecal_%j.o
#SBATCH --error=/data/users/pkunjal/cancer_genomics/logs/error_baserecal_%j.e

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

PROJECTDIR="/data/users/pkunjal/cancer_genomics"
MARKEDBAMDIR="$PROJECTDIR/alignments/marked"
OUTDIR="$PROJECTDIR/results/alignments/bqsr_tables"

REF="/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa"
KNOWN_DBSNP="/data/courses/cancergenomics/VAR_CALLING/dbsnp/GCF_000001405.40_alias.vcf.gz"
KNOWN_INDELS="/data/courses/cancergenomics/VAR_CALLING/known_indels/resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    gatk BaseRecalibrator \
        -I "$MARKEDBAMDIR/${ID}_marked.bam" \
        -R "$REF" \
        --known-sites "$KNOWN_DBSNP" \
        --known-sites "$KNOWN_INDELS" \
        -O "$OUTDIR/${ID}_recal_data.table"
done