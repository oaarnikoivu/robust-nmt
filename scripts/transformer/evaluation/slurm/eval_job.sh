#!/bin/bash 

##SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
##SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
##SBATCH --gres=gpu:1
##SBATCH --partition=devel 

#SBATCH -o /home/s2125219/slogs/slurm-%j.out
#SBATCH -e /home/s2125219/slogs/slurm-%j.err
#SBATCH -n 1
#SBATCH --gres=gpu:4
#SBATCH --mem=6000
#SBATCH --partition=Teach-Standard

# e.g. sbatch eval_job.sh eval_id_transformer europarl_5k_bpe_10000 europarl_5k 
# e.g. sbatch eval_job.sh eval_ood_transformer europarl_5k_bpe_10000 europarl_5k

# Activate conda environment 
source /home/s2125219/miniconda3/bin/activate
conda activate distillation 

eval_script=$1
experiment=$2
size=$3

bash ../${eval_script}.sh $experiment $size 
