#!/bin/bash
#SBATCH --job-name=r_analysis
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/skeane/CancerGenomicsProject/logs/R/RPlotting_%A_%a.out
#SBATCH --error=/data/users/skeane/CancerGenomicsProject/logs/R/RPlot_%A_%a.err
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4

module load R

Rscript --vanilla /data/users/skeane/CancerGenomicsProject/scripts/23.2-vep_plots.R