#!/bin/bash
#SBATCH --job-name=collect_metrics
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/output_collect_metrics_%j.o
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/error_collect_metrics_%j.e

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11
module load R/4.3.2-foss-2021a

PROJECTDIR="/data/users/epasnin/CancerGenomicsProject"
MARKEDBAMDIR="$PROJECTDIR/alignments/marked"
OUTDIR="$PROJECTDIR/metrics/collect_multiple_metrics"

REF="/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    INPUT_BAM="$MARKEDBAMDIR/${ID}_marked.bam"
    OUTPUT_PREFIX="$OUTDIR/${ID}"

    gatk CollectMultipleMetrics \
        -I "$INPUT_BAM" \
        -O "$OUTPUT_PREFIX" \
        -R "$REF"
done