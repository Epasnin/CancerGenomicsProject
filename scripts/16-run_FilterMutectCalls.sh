#!/bin/bash
#SBATCH --job-name=filterMutect2
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/epasnin/CancerGenomicsProject/logs/filterMutect2_%j.out
#SBATCH --error=/data/users/epasnin/CancerGenomicsProject/logs/filterMutect2_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

REFDIR=/data/courses/cancergenomics/VAR_CALLING/reference
VARIANTDIR=/data/users/epasnin/CancerGenomicsProject/results/variants
 
# fill the filter column    
gatk FilterMutectCalls \
    -R "$REFDIR"/ref_genome.fa \
    -V "$VARIANTDIR"/somatic.vcf.gz \
    -O "$VARIANTDIR"/somatic.filtered.vcf.gz
