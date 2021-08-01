#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

size=$1

DICT=$base/ft/$size/dict.txt

SRC=en_XX
TGT=fi_FI 

dest_dir=$base/mbart_processed/$size

fairseq-preprocess \
  --source-lang ${SRC} \
  --target-lang ${TGT} \
  --trainpref $base/ft/$size/train.spm \
  --validpref $base/ft/$size/dev.spm \
  --testpref $base/ft/$size/test.spm \
  --destdir $dest_dir \
  --thresholdtgt 0 \
  --thresholdsrc 0 \
  --srcdict ${DICT} \
  --tgtdict ${DICT} \
  --workers 70
