#!/bin/bash

#SBATCH -o /home/s2125219/slogs/slurm-%j.out
#SBATCH -e /home/s2125219/slogs/slurm-%j.err
#SBATCH -n 1
#SBATCH --gres=gpu:4
#SBATCH --mem=6000
#SBATCH --partition=Teach-Short

# e.g. sbatch train_transformer_baseline_job.sh europarl_5k_bpe_30000 20

base=../../../../

# Activate conda environment 
source /home/s2125219/miniconda3/bin/activate
conda activate distillation 

experiment=$1 
patience=$2

SCRATCH_DISK=/disk/scratch
SCRATCH_HOME=$SCRATCH_DISK/s2125219

src_path=$base/data-bin/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

rm -rf $dest_path # remove existing

mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

for seed in 1; do
    echo "Training baseline Transformer for $experiment with seed $seed:"

    checkpoint_path_scratch=$SCRATCH_HOME/$seed/checkpoints 
 
    rm -rf $checpoint_path_scratch
    mkdir -p $checkpoint_path_scratch

    bash ../train_transformer_baseline.sh $dest_path $checkpoint_path_scratch $patience $seed  

    echo ""
    echo "Done training baseline Transformer for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_baseline/$experiment/$seed 

    rm -rf $checkpoint_base
    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path_scratch/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
