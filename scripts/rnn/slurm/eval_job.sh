#!/bin/bash 

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=devel 

# e.g. sbatch translate_ood europarl_5k_bpe_10000 europarl_5k

# Activate conda environment 
#
#

eval_script=$1 
experiment=$2 
size=$3 

bash ../$eval_script.sh $experiment $size 
