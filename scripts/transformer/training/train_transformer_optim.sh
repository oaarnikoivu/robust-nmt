#!/bin/bash

data_dir=$1
checkpoint_dir=$2 

# Parameters to tune 
patience=$3
seed=$4
layers=$5 
heads=$6
ffn_dim=$7
dropout=$8
attn_dropout=$9
act_dropout=${10}
dec_layerdrop=${11}
enc_layerdrop=${12}
smooth=${13}

# remove --fp16 if gpu does not support!
# add --update-freq 8 if running on V100
fairseq-train $data_dir \
        --arch transformer --share-decoder-input-output-embed \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --encoder-layers $layers --decoder-layers $layers \
        --encoder-attention-heads $heads --decoder-attention-heads $heads \
        --encoder-ffn-embed-dim $ffn_dim --decoder-ffn-embed-dim $ffn_dim \
        --attention-dropout $attn_dropout \
        --decoder-layerdrop $dec_layerdrop \
        --encoder-layerdrop $enc_layerdrop \
        --activation-dropout $act_dropout \
        --lr 0.001 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
        --dropout $dropout --weight-decay 0.0001 \
        --criterion label_smoothed_cross_entropy --label-smoothing $smooth \
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
