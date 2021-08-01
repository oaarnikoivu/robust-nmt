#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

experiment=$1
size=$2
l=64

data=$base/data 

TRAIN_TEXT=$data/bpe_dropout/$size
TEXT=$data/in_domain/$size/$experiment/bpe/ 

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TRAIN_TEXT/bpe.train.augmented --validpref $TEXT/bpe.dev.truecased --testpref $TEXT/bpe.test.truecased \
    --destdir $base/data-bin-dropout/$experiment/$src-$tgt/$l
