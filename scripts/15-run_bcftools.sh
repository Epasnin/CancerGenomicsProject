#!/bin/bash
#SBATCH --job-name=bcftools
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/bcftools/bcftools_%j.out
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/bcftools/bcftools_%j.err

set -euo pipefail

module load BCFtools/1.12-GCC-10.3.0

VARIANTDIR=/data/users/${USER}/CancerGenomicsProject/output/variants
 
# create a vcf with variants passing filters (PASS)
bcftools view \
    -f PASS "$VARIANTDIR"/somatic.filtered.vcf.gz \
    -Oz > "$VARIANTDIR"/somatic.filtered.PASS.vcf.gz

bcftools index \
    --tbi "$VARIANTDIR"/somatic.filtered.PASS.vcf.gz
