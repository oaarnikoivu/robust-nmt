#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

src=en
tgt=fi

translations=$1

prefix=model/model.json

data=$base/data 
nematus=$base/tools/nematus 

# dev set same for all sub-corpora
ref=$data/in_domain/europarl_5k/dev.$tgt

# get BLEU
BLEU=`$PWD/postprocess.sh < $translations | \
        $nematus/data/multi-bleu-detok.perl $ref | \
        cut -f 3 -d ' ' | \
        cut -f 1 -d ','`

echo $BLEU
