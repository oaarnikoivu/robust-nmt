#!/bin/bash

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=small

script_dir=`dirname "$0"`
base=$script_dir/../../../..
scripts=$base/scripts

data=$base/data

# Activate conda environment 
#
#

SCRATCH_HOME=/raid/local_scratch/$SLURM_JOB_USER-$SLURM_JOB_ID

src_path=$data/data-bin-distilled/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

experiment=$1 

# Parameters to tune
patience=$2 
layers=$3 
heads=$4
ffn_dim=$5
dropout=$6
attn_dropout=$7
act_dropout=$8
dec_layerdrop=$9
enc_layerdrop=${10}
smooth=${11}

for seed in 1 2 3; do
    echo "Training transformer on distilled translations for $experiment with seed $seed:"

    checkpoint_path=$SCRATCH_HOME/$seed/checkpoints 
 
    mkdir -p $checkpoint_path
 
    bash ../train_transformer_distillation.sh $dest_path $checkpoint_path $patience $seed $layers $heads $ffn_dim $dropout $attn_dropout $act_dropout $dec_layerdrop $enc_layerdrop $smooth  

    echo ""
    echo "Done training transformer for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_distillation/$seed 

    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
