#!/bin/sh 

# e.g. bash translate.sh europarl_5k_bpe_10000 europarl_5k

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

devices=0

data=$base/data 

moses_scripts=$base/tools/mosesdecoder/scripts
nematus=$base/tools/nematus

data_dir=$data/in_domain/$size/$experiment/bpe

test=bpe.test.truecased.$src
ref=$data/in_domain/$size/test.$tgt

for seed in 1 2 3; do
    working_dir=$base/checkpoints/rnn/$experiment/$seed/model
    result_dir=$base/translations/rnn/$experiment/$seed/translations 

    mkdir -p $result_dir 

    CUDA_VISIBLE_DEVICES=$devices python $nematus/nematus/translate.py \
        -m $working_dir/model.best-valid-script \
        -i $data_dir/$test \
        -o $result_dir/$test.output
    
    # Post process 
    $PWD/postprocess.sh < $result_dir/$test.output > $result_dir/gen.out.detok.sys 

    # evaluate with sacrebleu 
    cat $result_dir/gen.out.detok.sys | sacrebleu $ref
done 
