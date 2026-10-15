#!/bin/bash
#SBATCH --job-name=mutect2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/mutect2_%j.out
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/mutect2_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

ALIGNDIR=/data/users/pkunjal/cancer_genomics/results/alignments/recal
REFDIR=/data/courses/cancergenomics/VAR_CALLING/reference
RESOURCEDIR=/data/courses/cancergenomics/VAR_CALLING/resources
OUTDIR=/data/users/epasnin/CancerGenomicsProject/results/variants

mkdir -p $OUTDIR

gatk Mutect2 \
    -R "$REFDIR"/ref_genome.fa \
    --intervals "$REFDIR"/exome_regions.bed.interval_list \
    -I "$ALIGNDIR"/tumor.recal.bam \
    -I "$ALIGNDIR"/normal.recal.bam \
    --normal normal \
    --germline-resource "$RESOURCEDIR"/af-only-gnomad.hg38.subset.vcf.gz \
    --panel-of-normals "$RESOURCEDIR"/1000g_pon.hg38.subset.vcf.gz \
    -O "$OUTDIR"/somatic.vcf.gz

