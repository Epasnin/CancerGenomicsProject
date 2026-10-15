#!/bin/bash
#SBATCH --job-name=bwa-mem2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/output_bwa-mem2_%j.o
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/error_bwa-mem2_%j.e

#load modules
module load BWA-MEM2/2.2.1-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0

set -euo pipefail

PROJECTDIR="/data/users/epasnin/CancerGenomicsProject"
READDIR="$PROJECTDIR/raw_data"
OUTDIR="$PROJECTDIR/alignments"

REF="/data/courses/cancergenomics/VAR_CALLING/bwa_idx/genome.fa"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    R1="$READDIR/${ID}.R1.fq.gz"
    R2="$READDIR/${ID}.R2.fq.gz"
    OUT_BAM="$OUTDIR/${ID}_aligned.bam"

    bwa-mem2 mem \
        -t 6 \
        -R "@RG\tID:${ID}\tSM:${ID}\tPL:ILLUMINA" \
        "$REF" \
        "$R1" "$R2" |
    samtools view \
        -b \
        -@ 1 \
        -o "$OUT_BAM" \
        -
done