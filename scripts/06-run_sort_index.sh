#!/bin/bash
#SBATCH --job-name=index_sort
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/output_index_sort_%j.o
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/error_index_sort_%j.e

set -euo pipefail

module load SAMtools/1.13-GCC-10.3.0

PROJECTDIR="/data/users/epasnin/CancerGenomicsProject"
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
done
    