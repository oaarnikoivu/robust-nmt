#!/bin/bash

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=small

script_dir=`dirname "$0"`
base=$script_dir/../../../..
scripts=$base/scripts

# Activate conda environment 
#
#

experiment=$1 

SCRATCH_HOME=/raid/local_scratch/$SLURM_JOB_USER-$SLURM_JOB_ID

data=$base/data

src_path=$data/data-bin/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

patience=$2 

for seed in 1 2 3; do
    echo "Training baseline Transformer for $experiment with seed $seed:"

    checkpoint_path_scratch=$SCRATCH_HOME/$seed/checkpoints 
 
    mkdir -p $checkpoint_path_scratch

    bash ../train_transformer_baseline.sh $dest_path $checkpoint_path_scratch $patience $seed  

    echo ""
    echo "Done training baseline Transformer for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_baseline/$experiment/$seed 

    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path_scratch/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
