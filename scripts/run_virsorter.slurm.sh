#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=60:00:00
#SBATCH --job-name=VirSorter
#SBATCH --qos=large
#SBATCH --partition=dpart
#SBATCH --ntasks-per-node=24
#SBATCH --mem=50000

## Example SLURM script to run VirSorter on a grid

hostname; date;
echo " Machine has $SLURM_CPUS_ON_NODE CPU cores"

## This is the script down here.
## You need to update the SAMPLE variable

FASTA="/cbcbhomes/jchopyk/projects/conserve_year_1/baby_virome_output/RWW_august/bacteria/RWW_august_bacteria_contigs.fasta"
OUTDIR="/cbcbhomes/jchopyk/projects/conserve_year_1/baby_virome_output/RWW_august/virsorter_output"

## Time to run!
time ../virsorter_wrapper.pl \
    --fna $FASTA \
    --virome 0 \
    --wdir $OUTDIR \
    --data-dir ../../virsorter-data/
