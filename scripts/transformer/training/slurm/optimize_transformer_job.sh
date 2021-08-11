#!/bin/bash

#SBATCH -o /home/s2125219/slogs/slurm-%j.out
#SBATCH -e /home/s2125219/slogs/slurm-%j.err
#SBATCH -n 1
#SBATCH --gres=gpu:4
#SBATCH --mem=6000
#SBATCH --partition=Teach-Short

# e.g. sbatch optimize_transformer_job.sh europarl_5k_bpe_10000 20 2 2 2048 0.5 0.0 0.0 0.0 0.0 0.5

# Activate conda environment 
source /home/s2125219/miniconda3/bin/activate
conda activate distillation

base=../../../../

experiment=$1 

SCRATCH_DISK=/disk/scratch
SCRATCH_HOME=$SCRATCH_DISK/s2125219

src_path=$base/data-bin/$experiment/en-fi
dest_path=$SCRATCH_HOME/en-fi

rm -rf $dest_path # remove existing

mkdir -p $dest_path

# Copy files required to run job 
rsync --archive --update --compress --progress $src_path/ $dest_path

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

for seed in 1; do
    echo "Optimizing transformer for $experiment with seed $seed:"

    checkpoint_path=$SCRATCH_HOME/$seed/checkpoints 
    
    rm -rf $checkpoint_path # delete existing
    mkdir -p $checkpoint_path
 
    bash ../train_transformer_optim.sh $dest_path $checkpoint_path $patience $seed $layers $heads $ffn_dim $dropout $attn_dropout $act_dropout $dec_layerdrop $enc_layerdrop $smooth  

    echo ""
    echo "Done training transformer for $experiment at seed $seed."
    echo ""

    # Move checkpoints back to base 
    checkpoint_base=$base/checkpoints/transformer_optim/$experiment/$seed 

    rm -rf $checkpoint_base # delete existing
    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path/ $checkpoint_base 

done

# Post experiment logging 
echo ""
echo "Job finished successfully."
