#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
domain=$2

devices=0

moses_scripts=$base/tools/mosesdecoder/scripts
nematus=$base/tools/nematus

data_dir=$data/out_domain/$domain/$experiment/bpe

for domain in law medical religion; do
    ref=$data/out_domain/$domain/test.deduped.$tgt 

    for seed in 1 2 3; do
        working_dir=$base/checkpoints/rnn/$experiment/$seed/model 
        result_dir=$base/translations/rnn/$experiment/$seed/$domain/translations 

        mkdir -p $result_dir
        
        CUDA_VISIBLE_DEVICES=$devices python $nematus/nematus/translate.py \
            -m $working_dir/model.best-valid-script \
            -i $data_dir/bpe.test.deduped.$src \
            -o $result_dir/bpe.test.output
        
        # Post process 
        $PWD/postprocess.sh < $result_dir/bpe.test.output > $result_dir/gen.out.detok.sys

        # evaluate with sacrebleu 
        cat $result_dir/gen.out.detok.sys | sacrebleu $ref
    done 
done 
