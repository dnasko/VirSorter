#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=60:00:00
#SBATCH --job-name=VirSorter
#SBATCH --qos=large
#SBATCH --partition=dpart
#SBATCH --ntasks-per-node=24
#SBATCH --mem=50000

hostname; date;
echo " Machine has $SLURM_CPUS_ON_NODE CPU cores"


ROOT="/cbcbhomes/jchopyk/projects/conserve_year_1"

## This is the script down here.
## You need to update the SAMPLE variable
SAMPLE="ZVI_august"
time $ROOT/metagenome_assembly_pipeline.sh \
    $ROOT/reads/${SAMPLE}_R1.fastq \
    $ROOT/reads/${SAMPLE}_R2.fastq \
    $SAMPLE \
    $ROOT/assemblies \
    24
date
