#!/bin/bash

data_dir=$1
checkpoint_dir=$2
patience=$3
seed=$4

# add --update-freq 8 if running on V100
# add --fp16 if running on V100
fairseq-train $data_dir \
    --arch transformer --share-decoder-input-output-embed \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    --lr 0.001 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    --dropout 0.1 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens 4096 \
    --patience $patience \
    --seed $seed \
	--ddp-backend no_c10d \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-detok moses \
    --eval-bleu-remove-bpe \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --no-epoch-checkpoints \
    --save-dir $checkpoint_dir
