#!/bin/bash
#SBATCH --job-name=fastqc_normal
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/output_fastqc_%j.o
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/error_fastqc_%j.e

WORKDIR="/data/users/epasnin/CancerGenomicsProject/raw_data"
OUTDIR="/data/users/epasnin/CancerGenomicsProject/fastqc"
CONTAINER="/containers/apptainer/fastqc-0.12.1.sif"

mkdir -p "$OUTDIR"

apptainer exec \
    --bind "$WORKDIR","$OUTDIR" \
    "$CONTAINER" \
    fastqc \
    --threads 1 \
    --outdir "$OUTDIR" \
    "$WORKDIR"/normal.*.gz