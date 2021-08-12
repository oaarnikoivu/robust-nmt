#!/bin/bash

# e.g. bash binarize_bpe_dropout_ood.sh europarl_5k_bpe_30000 europarl_5k

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

experiment=$1
size=$2

l=64

data=$base/data

for domain in law medical religion; do
    echo "Preprocessing the $domain domain:"

    OOD_TEXT=$data/out_domain/$domain/$experiment/bpe/

    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --srcdict $base/data-bin-dropout/$experiment/$src-$tgt/$l/dict.$src.txt \
        --tgtdict $base/data-bin-dropout/$experiment/$src-$tgt/$l/dict.$tgt.txt \
        --testpref $OOD_TEXT/bpe.test.truecased \
        --destdir $base/test-bin-dropout/$domain/$experiment/$src-$tgt/$l

    echo ""
done 

echo "Done."
