#!/usr/bin/env bash

#SBATCH --job-name=multiqc_cancer
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/multiQC/multiqc_%j.out
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/multiQC/multiqc_%j.err

# Set paths
CONTAINER="/containers/apptainer/multiqc-1.19.sif"
INPUT_FQC_DIR="/data/users/${USER}/CancerGenomicsProject/output/fastqc"
INPUT_FP_DIR="/data/users/${USER}/CancerGenomicsProject/output/fastp"
OUTPUT_DIR="/data/users/${USER}/CancerGenomicsProject/output/multiqc"

mkdir -p "$OUTPUT_DIR"

# Run MultiQC using Apptainer container
apptainer exec --bind /data "$CONTAINER" multiqc \
    "$INPUT_FQC_DIR" \
    "$INPUT_FP_DIR" \
    -o "$OUTPUT_DIR"

echo "MultiQC analysis complete!"