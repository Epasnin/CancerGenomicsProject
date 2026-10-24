#!/bin/bash
#SBATCH --job-name=fastp_normal
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/fastp/output_fastp_normal_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/fastp/error_fastp_normal_%j.e

DATA_DIR=/data/users/${USER}/CancerGenomicsProject/raw_data
OUTDIR=/data/users/${USER}/CancerGenomicsProject/output/fastp
CONTAINER=/containers/apptainer/fastp_0.24.1.sif
#N - Normal 
#T - Tumor
R1N=$DATA_DIR/normal.R1.fq.gz
R2N=$DATA_DIR/normal.R2.fq.gz
idN=normal

R1T=$DATA_DIR/tumor.R1.fq.gz
R2T=$DATA_DIR/tumor.R2.fq.gz
idT=tumor

mkdir -p "$OUTDIR"
#saves from checking both
for sample in N T; do
    if [[ "$sample" == "N" ]]; then
        R1="$R1N"
        R2="$R2N"
        id="$idN"
    else
        R1="$R1T"
        R2="$R2T"
        id="$idT"
    fi

    apptainer exec \
        --bind /data \
        "$CONTAINER" \
        fastp \
        -i "$R1" \
        -I "$R2" \
        -o "$OUTDIR/${id}.R1.fq.gz" \
        -O "$OUTDIR/${id}.R2.fq.gz" \
        -h "$OUTDIR/${id}.html" \
        -j "$OUTDIR/${id}.json"
done