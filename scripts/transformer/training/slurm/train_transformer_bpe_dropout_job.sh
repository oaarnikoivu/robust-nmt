#!/bin/bash

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=devel

# e.g. sbatch train_transformer_bpe_dropout_job.sh europarl_5k_bpe_30000 

# Activate conda environment 
#
#

base=../../../../

experiment=$1 

SCRATCH_HOME=/raid/local_scratch/$SLURM_JOB_USER-$SLURM_JOB_ID

src_path=$base/data-bin-dropout/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

rm -rf $dest_path # remove existing
mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

for seed in 1; do
    echo "Training Transformer with BPE-Dropout for $experiment with seed $seed:"

    checkpoint_path_scratch=$SCRATCH_HOME/$seed/checkpoints 

    rm -rf $checkpoint_path_scratch # remove existing 
    mkdir -p $checkpoint_path_scratch

    bash ../train_transformer_bpe_dropout.sh $dest_path $checkpoint_path_scratch $seed  

    echo ""
    echo "Done training Transformer with BPE-Dropout for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_bpe_dropout/$experiment/$seed 

    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path_scratch/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
