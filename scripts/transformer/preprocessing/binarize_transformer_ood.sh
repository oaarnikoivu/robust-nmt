#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

experiment=$1
size=$2

data=$base/data

IN_DOMAIN_TEXT=$data/in_domain/$size/$experiment/bpe/ 

for domain in law medical religion; do
    echo "Preprocessing the $domain domain:"
    
    OOD_TEXT=$data/out_domain/$domain/$experiment/bpe/

    # Preprocess (can remove trainpref and validpref and replace with srcdict and tgtdict from previous preprocessing, which is faster!) 
    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --srcdict $data_bin/$experiment/$src-$tgt/dict.$src.txt \
        --tgtdict $data_bin/$experiment/$src-$tgt/dict.$tgt.txt \
        --testpref $OOD_TEXT/bpe.test.truecased \
        --destdir $base/test-bin/$experiment/$domain/$src-$tgt 

    echo ""
done 

echo "Done."