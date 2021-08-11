#!/bin/bash

# e.g. bash preprocess_bpe_dropout.sh europarl_5k_bpe_30000 europarl_5k 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi 

experiment=$1
size=$2

vocab_threshold=10

BPEROOT=$base/tools/subword-nmt/subword_nmt

data=$base/data

prep=$data/in_domain/$size
aug=$data/bpe_dropout/$size 

BPE_CODE=$prep/$experiment/bpe/code 

# apply bpe to train, dev and valid 
for L in $src $tgt; do 
    for f in train.augmented.$L; do
        echo "apply_bpe.py to ${f}..."
        python $BPEROOT/apply_bpe.py -c $BPE_CODE --dropout 0.1 --vocabulary $prep/$experiment/bpe/vocab.$L --vocabulary-threshold $vocab_threshold < $aug/$f > $aug/bpe.$f 
    done 
done 
