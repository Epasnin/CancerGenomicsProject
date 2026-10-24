#!/bin/bash
#SBATCH --job-name=index_sort
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/SAM/output_index_sort_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/SAM/error_index_sort_%j.e

set -euo pipefail

module load SAMtools/1.13-GCC-10.3.0

PROJECTDIR="/data/users/${USER}/CancerGenomicsProject/output"
ALIGNMENTS="$PROJECTDIR/alignments"
OUTDIR="$ALIGNMENTS/sorted"

mkdir -p "$OUTDIR"

for ID in normal tumor
do
    INPUT_BAM="$ALIGNMENTS/${ID}_aligned.bam"
    SORTED_BAM="$OUTDIR/${ID}_sorted.bam"

    # Coordinate-sort the BAM
    samtools sort -@ 7 "$INPUT_BAM" -o "$SORTED_BAM"

    # Create the BAM index
    samtools index "$SORTED_BAM"

    # Sanity test
    samtools quickcheck -v $SORTED_BAM
done

    