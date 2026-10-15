#!/bin/bash
#SBATCH --job-name=pull_vep
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/vkiran/cancer_genomics/logs/output_pull_vep_%j.o
#SBATCH --error=/data/users/vkiran/cancer_genomics/logs/error_pull_vep_%j.e

CONTAINER_DIR=/data/users/vkiran/containers
mkdir -p "$CONTAINER_DIR" /data/users/vkiran/apptainer_tmp

# Keep Apptainer's temporary/cache files out of your small home directory
export APPTAINER_CACHEDIR=/data/users/vkiran/apptainer_tmp
export APPTAINER_TMPDIR=/data/users/vkiran/apptainer_tmp

# Official Ensembl VEP image, release 112 (matches the 112_GRCh38 cache)
apptainer pull "$CONTAINER_DIR"/vep_112.sif docker://ensemblorg/ensembl-vep:release_112.0

# Confirm the version
apptainer exec "$CONTAINER_DIR"/vep_112.sif vep --help | grep -i "ensembl-vep"
