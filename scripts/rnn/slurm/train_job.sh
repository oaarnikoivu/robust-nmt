#!/bin/bash

#SBATCH -o /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.out
#SBATCH -e /jmain01/home/JAD003/sxr01/oxa71-sxr01/slogs/slurm-%j.err
#SBATCH --gres=gpu:1
#SBATCH --partition=small

# sbatch train_job.sh europarl_5k_bpe_10000 europarl_5k 50

# Activate conda environment 
#
#

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

experiment=$1
size=$2
valid_freq=$3

SCRATCH_HOME=/raid/local_scratch/$SLURM_JOB_USER-$SLURM_JOB_ID

data=$base/data 

# Input data directory path on the DFS
data_dir=$data/in_domain/$size/$experiment/bpe
dict_dir=$data/in_domain/$size/$experiment

dest_data_dir=$SCRATCH_HOME/data_dir
dest_dict_dir=$SCRATCH_HOME/dict_dir
working_dir=$SCRATCH_HOME/model

mkdir -p $dest_data_dir
mkdir -p $dest_dict_dir
mkdir -p $working_dir

rsync --archive --update --compress --progress $data_dir/ $dest_data_dir
rsync --archive --update --compress --progress $dict_dir/ $dest_dict_dir

# Train model 

for seed in 1 2 3; do 
    bash ../train.sh $experiment $size $dest_data_dir $dest_dict_dir $working_dir $valid_freq

    model_base=$base/checkpoints/rnn/$experiment/$seed/model 

    mkdir -p $model_base 

    rsync --archive --update --compress --progress $working_dir/ $model_base 
done 

# Post experiment logging
echo ""
echo "Job completed successfuly."