#!/bin/bash

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=small

# e.g. sbatch train_transformer_distillation_job.sh europarl_5k_bpe_10000 3 [remaining hyperparameters...]

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
best_seed=$2

# Path to best model checkpoint of optimized Transformer
pretrain_model=$base/checkpoints/transformer_optim/$experiment/$best_seed

# Parameters to tune
patience=$3
layers=$4
heads=$5
ffn_dim=$6
dropout=$7
attn_dropout=$8
act_dropout=$9
dec_layerdrop=$10
enc_layerdrop=${11}
smooth=${12}

for seed in 1 2 3; do
    echo "Training transformer on distilled translations for $experiment with seed $seed:"

    checkpoint_path=$SCRATCH_HOME/$seed/checkpoints 
 
    mkdir -p $checkpoint_path
 
    bash ../train_transformer_distillation.sh $dest_path $checkpoint_path $pretrain_model $patience $seed $layers $heads $ffn_dim $dropout $attn_dropout $act_dropout $dec_layerdrop $enc_layerdrop $smooth  

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
