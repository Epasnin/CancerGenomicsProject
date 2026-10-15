#!/bin/bash
#SBATCH --job-name=bcftools
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/bcftools_%j.out
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/bcftools_%j.err

set -euo pipefail

module load BCFtools/1.12-GCC-10.3.0

VARIANTDIR=/data/users/epasnin/CancerGenomicsProject/results/variants
 
# create a vcf with variants passing filters (PASS)
bcftools view \
    -f PASS "$VARIANTDIR"/somatic.filtered.vcf.gz \
    -Oz > "$VARIANTDIR"/somatic.filtered.PASS.vcf.gz

bcftools index \
    --tbi "$VARIANTDIR"/somatic.filtered.PASS.vcf.gz
