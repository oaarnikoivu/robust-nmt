#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

data_dir=$3
dict_dir=$4
working_dir=$5

valid_freq=$6

nematus=$base/tools/nematus 

# GPUs to use 
devices=0

CUDA_VISIBLE_DEVICES=$devices python $nematus/nematus/train.py \
    --source_dataset $data_dir/bpe.train.truecased.$src \
    --target_dataset $data_dir/bpe.train.truecased.$tgt \
    --dictionaries $dict_dir/bpe.train.truecased.$src.json $dict_dir/bpe.train.truecased.$tgt.json \
    --valid_source_dataset $data_dir/bpe.dev.truecased.$src \
    --valid_target_dataset $data_dir/bpe.dev.truecased.$tgt \
    --model $working_dir/model \
    --token_batch_size 1000 \
    --reload latest_checkpoint \
    --label_smoothing 0.2 \
    --learning_rate 0.0005 \
    --model_type rnn \
    --rnn_enc_depth 1 \
    --rnn_enc_transition_depth 2 \
    --rnn_dec_depth 1 \
    --rnn_dec_base_transition_depth 2 \
    --tie_decoder_embeddings \
    --rnn_layer_normalisation \
    --rnn_dropout_embedding 0.5 \
    --rnn_dropout_hidden 0.5 \
    --rnn_dropout_source 0.3 \
    --rnn_dropout_target 0.3 \
    --optimizer adam \
    --adam_beta1 0.9 \
    --adam_beta2 0.98 \
    --patience 10 \
    --beam_size 5 \
    --valid_script $PWD/validate.sh \
    --valid_freq $valid_freq
