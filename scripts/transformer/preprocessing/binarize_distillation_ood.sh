#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

data=$base/data 

DISTILLED=$base/distillation_translations/$experiment 

for domain in law medical religion; do
	echo "Binarizing for the $domain domain..."

    TEST=$data/out_domain/$domain/$experiment/bpe 

	# Preprocess (can remove trainpref and validpref and replace with srcdict and tgtdict from previous preprocessing, which is faster!) 
	fairseq-preprocess --source-lang $src --target-lang $tgt \
		--trainpref $DISTILLED/bpe.train.distilled \
		--validpref $DISTILLED/bpe.dev.distilled \
		--testpref $TEST/bpe.test.truecased \
		--destdir data-bin-distilled/$experiment/ood/$domain/$src-$tgt
done

echo "Done."
