#!/bin/bash 

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=small

# Activate conda environment 
#
#

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

size=$1
seed=$2

SCRATCH=/raid/local_scratch/$SLURM_JOB_USER-$SLURM_JOB_ID

src_path=$base/mbart_processed/$size
dest_path=$SCRATCH/mBART/$size

mkdir -p $dest_path

rsync --archive --update --compress --progress $src_path/ $dest_path

for seed in 222 223 224; 
    echo "Finetuning mBART for $size at seed $seed:"

    checkpoint_path=$SCRATCH/mBART/$seed/checkpoints
    
    mkdir -p $checkpoint_path

    # Run the experiment
    bash finetune.sh $size $dest_path $checkpoint_path $seed

    checkpoint_base=$base/checkpoints/mbart/$seed/$size

    mkdir -p $checkpoint_base

    rsync --archive --update --compress --progress $checkpoint_path/ $checkpoint_base 

    echo ""
done 

# Post experiment logging
echo ""
echo "Job finished sucessfully."