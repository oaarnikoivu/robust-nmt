#!/bin/bash 

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=devel 

# e.g. sbatch teacher_translate.sh europarl europarl_bpe_2000

# Activate conda environment 
#
#

size=$1
experiment=$2 

bash ../teacher_translate.sh $size $experiment 
