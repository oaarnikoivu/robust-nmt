#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1

devices=0

moses_scripts=$base/tools/mosesdecoder/scripts
nematus=$base/tools/nematus

test=bpe.test.truecased.$src

for domain in law medical religion; do
    for seed in 1 2 3; do
        echo "Evaluating the $domain domain at seed $seed:"

        result_dir=$base/translations/rnn/$experiment/$seed/$domain

        mkdir -p $result_dir

        working_dir=$base/checkpoints/rnn/$experiment/$seed/model 
        data_dir=$data/out_domain/$domain/$experiment/bpe

        ref=$data/out_domain/$domain/test.dedup.$tgt 

        CUDA_VISIBLE_DEVICES=$devices python $nematus/nematus/translate.py \
            -m $working_dir/model.best-valid-script \
            -i $data_dir/$test \
            -o $result_dir/$test.output
        
        # Post process 
        $PWD/postprocess.sh < $result_dir/$test.output > $result_dir/gen.out.detok.sys

        # evaluate with sacrebleu 
        cat $result_dir/gen.out.detok.sys | sacrebleu $ref
    done 
done 
