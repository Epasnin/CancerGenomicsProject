#!/bin/bash
#SBATCH --job-name=bam_inspection
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/vkiran/cancer_genomics/logs/output_bam_inspection_%j.o
#SBATCH --error=/data/users/vkiran/cancer_genomics/logs/error_bam_inspection_%j.e

BAM_DIR=/data/courses/cancergenomics/VAR_CALLING/alignments
OUTDIR=/data/users/vkiran/cancer_genomics/bam_inspection
CONTAINER=/containers/apptainer/samtools-1.19.sif

mkdir -p "$OUTDIR"

for id in normal tumor; do
    BAM=$BAM_DIR/${id}.recal.bam

    # Header: sort order (@HD),chromosomes (@SQ), read groups (@RG), processing history (@PG)
    apptainer exec --bind /data "$CONTAINER" \
        samtools view -H "$BAM" > $OUTDIR/${id}.header.txt

    # First 10 alignment records: read length, CIGAR, flags
    apptainer exec --bind /data "$CONTAINER" \
        samtools view "$BAM" | head -n 10 > $OUTDIR/${id}.first_records.txt

    # Mapping summary: total, mapped, properly paired, duplicates
    apptainer exec --bind /data "$CONTAINER" \
        samtools flagstat -@ 4 "$BAM" > $OUTDIR/${id}.flagstat.txt
done
