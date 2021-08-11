#!/bin/bash

# e.g. bash preprocess.sh europarl_5k_bpe_10000 europarl_5k 10000

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

BPE_TOKENS=$3

vocab_threshold=10

BPEROOT=$base/tools/subword-nmt/subword_nmt

data=$base/data

prep=$data/in_domain/$size

shared_models=$base/shared_models

rm -rf $prep/$experiment/bpe

mkdir -p $prep/$experiment/bpe 

# normalize train, dev and test in subsets 
for corpus in train dev test; do 
    cat $prep/$corpus.$src | $NORM_PUNC > $prep/$corpus.normalized.$src 
    cat $prep/$corpus.$tgt | $NORM_PUNC > $prep/$corpus.normalized.$tgt
done 

# tokenize train, dev and test in subsets
for corpus in train dev test; do 
    cat $prep/$corpus.normalized.$src | $TOKENIZER -a -q -l $src > $prep/$corpus.tokenized.$src 
    cat $prep/$corpus.normalized.$tgt | $TOKENIZER -a -q -l $tgt > $prep/$corpus.tokenized.$tgt
done

# apply truecase learned on full training corpus to train, dev and test in subsets 
for corpus in train dev test; do
    $MOSES/recaser/truecase.perl -model $shared_models/$src$tgt.truecase-model.$src < $prep/$corpus.tokenized.$src > $prep/$corpus.truecased.$src
    $MOSES/recaser/truecase.perl -model $shared_models/$src$tgt.truecase-model.$tgt < $prep/$corpus.tokenized.$tgt > $prep/$corpus.truecased.$tgt
done 

BPE_CODE=$prep/$experiment/bpe/code 

# Learn a joint BPE and vocabulary on (in-domain!) training source and target data
echo "learn_joint_bpe_and_vocab.py on source and target"
python $BPEROOT/learn_joint_bpe_and_vocab.py \
    --input $prep/train.truecased.$src $prep/train.truecased.$tgt \
    -s $BPE_TOKENS \
    -o $BPE_CODE \
    --write-vocabulary $prep/$experiment/bpe/vocab.$src $prep/$experiment/bpe/vocab.$tgt 

# apply bpe to train, dev and test
for L in $src $tgt; do 
    for f in train.truecased.$L dev.truecased.$L test.truecased.$L; do
        echo "apply_bpe.py to ${f}..."
        python $BPEROOT/apply_bpe.py -c $BPE_CODE --vocabulary $prep/$experiment/bpe/vocab.$L --vocabulary-threshold $vocab_threshold < $prep/$f > $prep/$experiment/bpe/bpe.$f 
    done 
done 
