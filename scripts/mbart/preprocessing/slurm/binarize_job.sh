#!/bin/bash 

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=devel

# e.g. bash binarize_ood europarl_5k

# Activate conda environment 
#
#

bin_script=$1 
size=$2 

bash ../$bin_script.sh $size 
