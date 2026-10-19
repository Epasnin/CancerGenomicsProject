#!/bin/bash
#SBATCH --job-name=vep_clinvar
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/vep_clinvar_%j.out
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/vep_clinvar_%j.err

set -euo pipefail

PROJECTDIR="/data/users/epasnin/CancerGenomicsProject"
VEP_CONTAINER="/data/users/vkiran/containers/vep_112.sif"
VEP_CACHE="/data/databases/vep"
INPUT_VCF="$PROJECTDIR/results/variants/somatic.filtered.PASS.vcf.gz"
CLINVAR="/data/courses/cancergenomics/VAR_CALLING/resources/clinvar/clinvar.vcf.gz"
REF="/data/courses/cancergenomics/VAR_CALLING/reference/ref_genome.fa"

OUTDIR="$PROJECTDIR/results/annotation"
ANNOTATED="$OUTDIR/vep_clinvar.txt"
FILTERED="$OUTDIR/vep_clinvar_filtered.txt"
SUMMARY="$OUTDIR/summary.txt"

mkdir -p "$OUTDIR"

# Check required input files.
for FILE in "$VEP_CONTAINER" "$INPUT_VCF" "$CLINVAR" "$CLINVAR.tbi"
do
    if [[ ! -r "$FILE" ]]; then
        echo "ERROR: Cannot read $FILE" >&2
        exit 1
    fi
done

if [[ ! -d "$VEP_CACHE" ]]; then
    echo "ERROR: Cache directory not found: $VEP_CACHE" >&2
    exit 1
fi

# Annotate the PASS VCF with VEP and ClinVar.
apptainer exec \
    --bind /data \
    "$VEP_CONTAINER" \
    vep \
    --input_file "$INPUT_VCF" \
    --output_file "$ANNOTATED" \
    --format vcf \
    --tab \
    --species homo_sapiens \
    --assembly GRCh38 \
    --cache \
    --merged \
    --cache_version 112 \
    --dir_cache "$VEP_CACHE" \
    --FASTA "$REF" \
    --offline \
    --symbol \
    --everything \
    --fork "$SLURM_CPUS_PER_TASK" \
    --force_overwrite \
    --custom \
    "$CLINVAR,ClinVar,vcf,exact,0,CLNSIG,CLNREVSTAT,CLNDN"

# Retain annotations meeting ANY of the criteria.
apptainer exec \
    --bind /data \
    "$VEP_CONTAINER" \
    filter_vep \
    -i "$ANNOTATED" \
    -o "$FILTERED" \
    --force_overwrite \
    --filter \
    "(IMPACT is HIGH or IMPACT is MODERATE) or
     (SIFT match deleterious or PolyPhen match probably_damaging) or
     (ClinVar_CLNSIG match Pathogenic or ClinVar_CLNSIG match Likely_pathogenic)"

# Count annotation rows, not unique variants.
awk '!/^#/ && NF {n++} END {print "Input annotation rows:", n+0}' \
    "$ANNOTATED" > "$SUMMARY"

awk '!/^#/ && NF {n++} END {print "Retained annotation rows:", n+0}' \
    "$FILTERED" >> "$SUMMARY"

# Find the Consequence column by its header name.
CONSEQUENCE_COL=$(awk -F '\t' '
    /^#Uploaded_variation/ {
        for (i=1; i<=NF; i++)
            if ($i == "Consequence") {
                print i
                exit
            }
    }
' "$FILTERED")

if [[ -z "$CONSEQUENCE_COL" ]]; then
    echo "ERROR: Consequence column not found." >&2
    exit 1
fi

echo "" >> "$SUMMARY"
echo "Retained consequence combinations:" >> "$SUMMARY"

awk -F '\t' -v col="$CONSEQUENCE_COL" \
    '!/^#/ && NF {print $col}' "$FILTERED" |
    sort |
    uniq -c |
    sort -nr >> "$SUMMARY"