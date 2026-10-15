#!/bin/bash
#SBATCH --job-name=hsmetrics
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=01:30:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/vkiran/cancer_genomics/logs/output_hsmetrics_%j.o
#SBATCH --error=/data/users/vkiran/cancer_genomics/logs/error_hsmetrics_%j.e

BAM_DIR=/data/courses/cancergenomics/VAR_CALLING/alignments
REF=/data/courses/cancergenomics/VAR_CALLING/reference/ref_genome.fa
INTERVALS=/data/courses/cancergenomics/VAR_CALLING/reference/exome_regions.bed.interval_list

WORKDIR=/data/users/vkiran/cancer_genomics
OUTDIR=$WORKDIR/hs_metrics
MQC_DIR=$WORKDIR/multiqc_bam_qc

GATK=/containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif
MULTIQC=/containers/apptainer/multiqc-1.33.sif

mkdir -p "$OUTDIR" "$MQC_DIR"

# 1. Collect HsMetrics for each sample (same file used as bait and target intervals)
for id in normal tumor; do
    apptainer exec --bind /data "$GATK" \
        gatk --java-options "-Xmx12g" CollectHsMetrics \
        -I $BAM_DIR/${id}.recal.bam \
        -O $OUTDIR/${id}.hs_metrics.txt \
        -R $REF \
        --BAIT_INTERVALS $INTERVALS \
        --TARGET_INTERVALS $INTERVALS
done

# 2. MultiQC on HsMetrics + flagstat results (separate report name and folder)
apptainer exec --bind /data "$MULTIQC" \
    multiqc -f \
    $OUTDIR $WORKDIR/bam_inspection \
    -o $MQC_DIR \
    -n multiqc_bam_qc
    