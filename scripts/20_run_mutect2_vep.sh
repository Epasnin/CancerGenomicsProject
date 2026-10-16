#!/bin/bash
#SBATCH --job-name=vep_mutect2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/pkunjal/cancer_genomics/logs/output_vep_mutect2_%j.o
#SBATCH --error=/data/users/pkunjal/cancer_genomics/logs/error_vep_mutect2_%j.e

set -euo pipefail

PROJECTDIR="/data/users/pkunjal/cancer_genomics"
OUTDIR="$PROJECTDIR/results/vep_mutect2"
INPUT_VCF="/data/users/epasnin/CancerGenomicsProject/results/variants/somatic.filtered.PASS.vcf.gz"

CONTAINER="/data/users/vkiran/containers/vep_112.sif"
CACHE="/data/databases/vep"
FASTA="/data/references/Homo_sapiens/Ensembl/GRCh38/Sequence/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

mkdir -p "$OUTDIR"

COMMON="--offline --cache --merged --dir_cache $CACHE --cache_version 112 \
--species homo_sapiens --assembly GRCh38 --format vcf --fasta $FASTA \
--everything --fork 8 --force_overwrite"
# 1) Annotated VCF
apptainer exec --bind /data "$CONTAINER" vep \
    -i "$INPUT_VCF" -o "$OUTDIR/chr6ch17_mutect2_annotated.vcf" \
    --vcf $COMMON

# 2) Tab-separated version (deliverable)
apptainer exec --bind /data "$CONTAINER" vep \
    -i "$INPUT_VCF" -o "$OUTDIR/chr6ch17_mutect2_annotated.txt" \
    --tab $COMMON