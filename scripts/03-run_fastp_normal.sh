#!/bin/bash
#SBATCH --job-name=fastp_normal
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/vkiran/cancer_genomics/logs/output_fastp_normal_%j.o
#SBATCH --error=/data/users/vkiran/cancer_genomics/logs/error_fastp_normal_%j.e

FASTQ_DIR=/data/users/vkiran/cancer_genomics/TMP
OUTDIR=/data/users/vkiran/cancer_genomics/fastp_output
CONTAINER=/containers/apptainer/fastp_0.24.1.sif

R1=$FASTQ_DIR/normal.R1.fq.gz
R2=$FASTQ_DIR/normal.R2.fq.gz
id=normal

mkdir -p "$OUTDIR"

apptainer exec \
  --bind /data \
  "$CONTAINER" \
  fastp \
  -i ${R1} \
  -I ${R2} \
  -o $OUTDIR/${id}.R1.fq.gz \
  -O $OUTDIR/${id}.R2.fq.gz \
  -h $OUTDIR/${id}.html \
  -j $OUTDIR/${id}.json
