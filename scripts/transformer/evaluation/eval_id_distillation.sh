#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

bin_dir=$base/data-bin-distilled/$experiment/$src-$tgt

for seed in 1 2 3; do
	echo "In domain evaluation at seed $seed:"

	checkpoint_dir=$base/checkpoints/transformer_distillation/$seed 

	result_dir=$base/translations/transformer_distillation/$size/$seed 

	fairseq-generate $bin_dir \
		--path $checkpoint_dir/checkpoint_best.pt \
		--beam 5 \
		--remove-bpe \
		--sacrebleu \
		--results-path $result_dir

	grep ^H $result_dir/generate-test.txt | cut -f3- | sacremoses detruecase | sacremoses detokenize > $result_dir/gen.out.detok.sys
	grep ^T $result_dir/generate-test.txt | cut -f2- | sacremoses detruecase | sacremoses detokenize > $result_dir/gen.out.detok.ref

	# Evaluate against reference using sacreBLEU
	cat $result_dir/gen.out.detok.sys | sacrebleu $result_dir/gen.out.detok.ref

	echo ""
done

echo "Done."
