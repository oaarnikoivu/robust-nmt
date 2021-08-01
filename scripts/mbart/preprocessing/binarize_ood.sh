#!/bin/sh

# e.g. bash binarize_ood.sh europarl_5k 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

size=$1

DICT=$base/ft/$size/dict.txt

SRC=en_XX
TGT=fi_FI 

for domain in law medical religion; do
	dest_dir=$base/mbart_processed/$size/$domain

	fairseq-preprocess \
  		--source-lang ${SRC} \
  		--target-lang ${TGT} \
  		--trainpref $base/ft/$size/train.spm \
  		--validpref $base/ft/$size/dev.spm \
  		--testpref $base/ft/$domain/test.deduped.spm \
  		--destdir $dest_dir \
  		--thresholdtgt 0 \
  		--thresholdsrc 0 \
  		--srcdict ${DICT} \
  		--tgtdict ${DICT} \
  		--workers 70
done

echo "Done."