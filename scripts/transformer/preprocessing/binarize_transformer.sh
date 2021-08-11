#!/bin/bash

# e.g. bash binarize_transformer.sh europarl_5k_bpe_1000 europarl_5k

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

experiment=$1
size=$2

data=$base/data

rm -rf $base/data-bin/$experiment/

TEXT=$data/in_domain/$size/$experiment/bpe/ 

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/bpe.train.truecased --validpref $TEXT/bpe.dev.truecased --testpref $TEXT/bpe.test.truecased \
    --destdir $base/data-bin/$experiment/$src-$tgt 
