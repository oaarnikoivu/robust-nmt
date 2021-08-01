#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en 
tgt=fi 

experiment=$1
size=$2

nematus_dir=$base/tools/nematus 
data=$base/data 

# Build network dictionaries for seperate source / target vocabularies for train, dev and test 
for corpus in train dev test; do 
    $nematus_dir/data/build_dictionary.py \
        $data/in_domain/$size/$experiment/bpe/bpe.$corpus.truecased.$src \
        $data/in_domain/$size/$experiment/bpe/bpe.$corpus.truecased.$tgt 
done 

echo "Done."
