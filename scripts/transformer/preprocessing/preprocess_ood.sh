#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en 
tgt=fi

MOSES=$base/tools/mosesdecoder/scripts 
TOKENIZER=$MOSES/tokenizer/tokenizer.perl 
NORM_PUNC=$MOSES/tokenizer/normalize-punctuation.perl

experiment=$1
size=$2
domain=$3

vocab_threshold=10

BPEROOT=../subword-nmt/subword_nmt

data=$base/data

prep=.$data/in_domain/$size
ood=$data/out_domain/$domain

shared_models=$base/shared_models

BPE_CODE=$prep/$EXPERIMENT/bpe/code 

cd $ood && mkdir -p $EXPERIMENT && cd $EXPERIMENT && mkdir -p bpe && cd $scripts/preprocessing

# deduplicate ood test set
src_file=$ood/test.$src  
tgt_file=$ood/test.$tgt

paste $src_file $tgt_file | awk '!x[$0]++' > $ood/test.dedup
cut -f1 $ood/test.dedup > $ood/test.dedup.$src 
cut -f2 $ood/test.dedup > $ood/test.dedup.$tgt

# normalize ood test set
cat $ood/test.dedup.$src | $NORM_PUNC > $ood/test.normalized.$src 
cat $ood/test.dedup.$tgt | $NORM_PUNC > $ood/test.normalized.$tgt

# tokenize ood test set
cat $ood/test.normalized.$src | $TOKENIZER -a -q -l $src > $ood/test.tokenized.$src 
cat $ood/test.normalized.$tgt | $TOKENIZER -a -q -l $tgt > $ood/test.tokenized.$tgt

# apply truecase learned on full (in domain!) training corpus to ood test set
$MOSES/recaser/truecase.perl -model $shared_models/$src$tgt.truecase-model.$src < $ood/test.tokenized.$src > $ood/test.truecased.$src
$MOSES/recaser/truecase.perl -model $shared_models/$src$tgt.truecase-model.$tgt < $ood/test.tokenized.$tgt > $ood/test.truecased.$tgt

# apply bpe learned on (in-domain!) training corpus to ood test set
for L in $src $tgt; do 
    for f in test.truecased.$L; do
        echo "apply_bpe.py to ${f}..."
        python $BPEROOT/apply_bpe.py -c $BPE_CODE --vocabulary $prep/$experiment/bpe/vocab.$L --vocabulary-threshold $vocab_threshold < $ood/$f > $ood/$experiment/bpe/bpe.$f 
    done 
done 
