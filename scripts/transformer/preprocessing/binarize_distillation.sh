#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

data=$base/data 

DISTILLED=$base/translations/distillation/teacher/$experiment
TEST=$data/in_domain/$size/$experiment/bpe 

fairseq-preprocess --source-lang $src --target-lang $tgt \
--trainpref $DISTILLED/bpe.train.distilled --validpref $DISTILLED/bpe.dev.distilled --testpref $TEST/bpe.test.truecased \
--destdir $base/data-bin-distilled/$experiment/$src-$tgt
