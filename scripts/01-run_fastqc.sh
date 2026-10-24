#!/bin/bash
#SBATCH --job-name=fastqc_normal
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/fastqc/output_fastqc_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/fastqc/error_fastqc_%j.e

WORKDIR="/data/users/${USER}/CancerGenomicsProject/raw_data"
OUTDIR="/data/users/${USER}/CancerGenomicsProject/output/fastqc"
CONTAINER="/containers/apptainer/fastqc-0.12.1.sif"

mkdir -p "$OUTDIR"
#Produces normal and tumor fastqc for both ez
apptainer exec \
    --bind "$WORKDIR","$OUTDIR" \
    "$CONTAINER" \
    fastqc \
    --threads 1 \
    --outdir "$OUTDIR" \
    "$WORKDIR"/normal.*.gz \
    "$WORKDIR"/tumor.*.gz