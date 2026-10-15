#!/usr/bin/env bash

#SBATCH --job-name=multiqc_cancer
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/pkunjal/cancer_genomics/logs/multiqc_%j.out
#SBATCH --error=/data/users/pkunjal/cancer_genomics/logs/multiqc_%j.err

# Set paths
CONTAINER="/containers/apptainer/multiqc-1.19.sif"
INPUT_DIR="/data/users/pkunjal/cancer_genomics/results/fastq"
OUTPUT_DIR="/data/users/pkunjal/cancer_genomics/results/multiqc"

mkdir -p "$OUTPUT_DIR"

# Run MultiQC using Apptainer container
apptainer exec --bind /data "$CONTAINER" multiqc \
    "$INPUT_DIR" \
    -o "$OUTPUT_DIR"

echo "MultiQC analysis complete!"