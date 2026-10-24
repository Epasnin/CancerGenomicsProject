#!/bin/bash
#SBATCH --job-name=filter_vep
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/vep_filter/output_filter_vep_%j.o
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/vep_filter/error_filter_vep_%j.e

set -euo pipefail

PROJECTDIR="/data/users/${USER}/CancerGenomicsProject"
VEP_CONTAINER="/data/users/vkiran/containers/vep_112.sif"
INPUT="/data/users/${USER}/CancerGenomicsProject/output/vep_mutect2/chr6ch17_mutect2_annotated.txt"
OUTDIR="$PROJECTDIR/output/annotation"
OUTPUT="$OUTDIR/vep_filtered.txt"

mkdir -p "$OUTDIR"

# Keep annotations meeting ANY of these criteria.
apptainer exec \
    --bind /data \
    "$VEP_CONTAINER" \
    filter_vep \
    -i "$INPUT" \
    -o "$OUTPUT" \
    --force_overwrite \
    --filter \
    "(IMPACT is HIGH or IMPACT is MODERATE) or
     (SIFT match deleterious or PolyPhen match probably_damaging)"

# Count annotation rows, excluding headers.
awk '!/^#/ && NF {n++} END {print "Input annotation rows:", n+0}' \
    "$INPUT" > "$OUTDIR/basic_filter_summary.txt"

awk '!/^#/ && NF {n++} END {print "Retained annotation rows:", n+0}' \
    "$OUTPUT" >> "$OUTDIR/basic_filter_summary.txt"