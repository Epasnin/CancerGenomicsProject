#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/BAMMultiQC/output_multiqc_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/BAMMultiQC/error_multiqc_%j.e

set -euo pipefail

module load MultiQC

PROJECTDIR="/data/users/${USER}/CancerGenomicsProject/output"
FASTQCDIR="$PROJECTDIR/fastqc"
FASTPDIR="$PROJECTDIR/fastp"
MARKEDBAMDIR="$PROJECTDIR/alignments/marked"
METRICSDIR="$PROJECTDIR/metrics/collect_multiple_metrics"
OUTDIR="$PROJECTDIR/multiqc/post_alignment"

mkdir -p "$OUTDIR"

multiqc \
    "$FASTQCDIR" \
    "$FASTPDIR" \
    "$MARKEDBAMDIR" \
    "$METRICSDIR" \
    --outdir "$OUTDIR" \
    --filename multiqc_report.html \
    --force