#!/bin/bash

#SBATCH -o /home/s2125219/slogs/slurm-%j.out
#SBATCH -e /home/s2125219/slogs/slurm-%j.err
#SBATCH -n 1
#SBATCH --gres=gpu:4
#SBATCH --mem=6000
#SBATCH --partition=Teach-Short

# e.g. sbatch train_transformer_distillation_job.sh europarl_5k_bpe_10000 1 20 2 2 2048 0.5 0.0 0.0 0.0 0.0 0.5

# Activate conda environment 
source /home/s2125219/miniconda3/bin/activate
conda activate distillation

base=../../../../

experiment=$1 
best_seed=$2

SCRATCH_DISK=/disk/scratch
SCRATCH_HOME=$SCRATCH_DISK/s2125219

src_path=$base/data-bin-distilled/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

rm -rf $dest_path # remove existing
mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

# Path to best model checkpoint of optimized Transformer
pretrain_model=$base/checkpoints/transformer_optim/$experiment/$best_seed

pretrain_path=$SCRATCH_HOME/distil-checkpoints/$size/checkpoints

rm -rf $pretrain_path # remove existing
mkdir -p $pretrain_path

# Copy pretrained model to scratch
rsync --archive --update --compress --progress $pretrain_model/ $pretrain_path

# Parameters to tune
patience=$3
layers=$4
heads=$5
ffn_dim=$6
dropout=$7
attn_dropout=$8
act_dropout=$9
dec_layerdrop=${10}
enc_layerdrop=${11}
smooth=${12}

for seed in 1; do
    echo "Training transformer on distilled translations for $experiment with seed $seed:"

    checkpoint_path=$SCRATCH_HOME/$seed/checkpoints 
 
    rm -rf $checkpoint_path # remove existing
    mkdir -p $checkpoint_path
 
    bash ../train_transformer_distillation.sh $dest_path $checkpoint_path $pretrain_path $patience $seed $layers $heads $ffn_dim $dropout $attn_dropout $act_dropout $dec_layerdrop $enc_layerdrop $smooth  

    echo ""
    echo "Done training transformer for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_distillation/$experiment/$seed 

    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
