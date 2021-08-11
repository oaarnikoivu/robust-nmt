#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi 

MOSES=$base/tools/mosesdecoder/scripts
TOKENIZER=$MOSES/tokenizer/tokenizer.perl 
CLEAN=$MOSES/training/clean-corpus-n.perl 
NORM_PUNC=$MOSES/tokenizer/normalize-punctuation.perl

data=$base/data 

full_train_corpus=$data/in_domain/full

rm -rf $base/shared_models 
mkdir -p $base/shared_models

# normalize full training corpus
cat $full_train_corpus/train.$src | $NORM_PUNC > $full_train_corpus/train.normalized.$src 
cat $full_train_corpus/train.$tgt | $NORM_PUNC > $full_train_corpus/train.normalized.$tgt

# tokenize full training corpus 
cat $full_train_corpus/train.normalized.$src | $TOKENIZER -a -q -l $src > $full_train_corpus/train.tokenized.$src 
cat $full_train_corpus/train.normalized.$tgt | $TOKENIZER -a -q -l $tgt > $full_train_corpus/train.tokenized.$tgt

# learn truecase model on full training corpus (one for each language)
$MOSES/recaser/train-truecaser.perl -corpus $full_train_corpus/train.tokenized.$src -model $base/shared_models/$src$tgt.truecase-model.$src 
$MOSES/recaser/train-truecaser.perl -corpus $full_train_corpus/train.tokenized.$tgt -model $base/shared_models/$src$tgt.truecase-model.$tgt 
