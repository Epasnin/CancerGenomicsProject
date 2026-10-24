#!/bin/bash
#SBATCH --job-name=bam_inspection
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/FLAGST/output_bam_inspection_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/FLAGST/error_bam_inspection_%j.e

BAM_DIR=/data/courses/cancergenomics/VAR_CALLING/alignments
OUTDIR=/data/users/${USER}/CancerGenomicsProject/output/bam_inspection
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
