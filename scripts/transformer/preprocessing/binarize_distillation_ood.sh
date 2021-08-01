#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

data=$base/data 

for domain in law medical religion; do
	echo "Binarizing for the $domain domain..."

    TEST=$data/out_domain/$domain/$experiment/bpe 

	fairseq-preprocess --source-lang $src --target-lang $tgt \
		--srcdict $base/data-bin-distilled/$experiment/$src-$tgt/dict.$src.txt \
		--tgtdict $base/data-bin-distilled/$experiment/$src-$tgt/dict.$tgt.txt \
		--testpref $TEST/bpe.test.truecased \
		--destdir $base/test-bin-distilled/$experiment/$domain/$src-$tgt
done

echo "Done."
