#!/bin/bash
#SBATCH --job-name=vep_basic
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/vkiran/cancer_genomics/logs/output_vep_basic_%j.o
#SBATCH --error=/data/users/vkiran/cancer_genomics/logs/error_vep_basic_%j.e

INPUT=/data/users/vkiran/cancer_genomics/cancer_variants.vcf
OUTDIR=/data/users/vkiran/cancer_genomics/vep_basic
CONTAINER=/data/users/vkiran/containers/vep_112.sif
CACHE=/data/databases/vep
FASTA=/data/references/Homo_sapiens/Ensembl/GRCh38/Sequence/Homo_sapiens.GRCh38.dna.primary_assembly.fa

mkdir -p "$OUTDIR"

# Options shared by all three runs (offline, merged 112 GRCh38 cache)
COMMON="--offline --cache --merged --dir_cache $CACHE --cache_version 112 \
        --species homo_sapiens --assembly GRCh38 --format vcf \
        --fasta $FASTA --fork 4 --force_overwrite"

# Run 1: default all overlapping transcripts per variant
apptainer exec --bind /data "$CONTAINER" \
    vep -i "$INPUT" $COMMON \
    --symbol --sift b --polyphen b --domains \
    -o $OUTDIR/cancer_variants_default.txt

# Run 2: --pick one consequence per variant
apptainer exec --bind /data "$CONTAINER" \
    vep -i "$INPUT" $COMMON \
    --symbol --sift b --polyphen b --domains --pick \
    -o $OUTDIR/cancer_variants_pick.txt

# Run 3: --everything all annotation options
apptainer exec --bind /data "$CONTAINER" \
    vep -i "$INPUT" $COMMON \
    --everything \
    -o $OUTDIR/cancer_variants_everything.txt
 