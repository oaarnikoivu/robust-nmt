#!/bin/bash 

# e.g. bash copy_corpus.sh europarl_5k 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

size=$1

data=$base/data 

orig_file_en=$data/in_domain/$size/train.truecased.en
dest_file_en=$data/bpe_dropout/$size/train.augmented.en

orig_file_fi=$data/in_domain/$size/train.truecased.fi
dest_file_fi=$data/bpe_dropout/$size/train.augmented.fi 

# l = 64 -> How many times to segment 
for i in {1..64}; do 
    cat $orig_file_en >> $dest_file_en
    cat $orig_file_fi >> $dest_file_fi
done
