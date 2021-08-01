#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

experiment=$1
size=$2

data=$base/data
data_bin=$base/data-bin

IN_DOMAIN_TEXT=$data/in_domain/$size/$experiment/bpe/ 
DICT=$data_bin/$experiment/$src-$tgt

for domain in law medical religion; do
    echo "Preprocessing the $domain domain:"

    rm -rf data-bin/ood/$domain/$experiment/
    
    OOD_TEXT=$data/out_domain/$domain/$experiment/bpe/

    # Preprocess (can remove trainpref and validpref and replace with srcdict and tgtdict from previous preprocessing, which is faster!) 
    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --trainpref $IN_DOMAIN_TEXT/bpe.train.truecased \
        --validpref $IN_DOMAIN_TEXT/bpe.dev.truecased \
        --testpref $OOD_TEXT/bpe.test.truecased \
        --destdir $data_bin/ood/$domain/$experiment/$src-$tgt 

    echo ""
done 

echo "Done."
