#!/bin/bash
#SBATCH --job-name=filterMutect2
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/%u/CancerGenomicsProject/logs/Filter_Mutect2/filterMutect2_%j.out
#SBATCH --error=/data/users/%u/CancerGenomicsProject/logs/Filter_Mutect2/filterMutect2_%j.err

set -euo pipefail

module load GATK/4.2.6.1-GCCcore-10.3.0-Java-11

REFDIR=/data/courses/cancergenomics/VAR_CALLING/reference

VARIANTDIR=/data/users/${USER}/CancerGenomicsProject/output/variants
 
# fill the filter column    
gatk FilterMutectCalls \
    -R "$REFDIR"/ref_genome.fa \
    -V "$VARIANTDIR"/somatic.vcf.gz \
    -O "$VARIANTDIR"/somatic.filtered.vcf.gz
