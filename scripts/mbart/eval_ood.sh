#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

size=$1

langs=ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN

for domain in law medical religion; do
	for seed in 222 223 224 225; do
		echo "Evaluating the $domain domain at seed $seed:"

		DATA_PATH=$base/mbart_processed/$size/$domain
		checkpoint_dir=$base/checkpoints/mbart/$seed/$size

        outdir=$base/translations/mbart/$seed/$domain 

		mkdir -p $outdir

		fairseq-generate $DATA_PATH \
  			--path $checkpoint_dir/checkpoint_best.pt \
  			--task translation_from_pretrained_bart \
  			--gen-subset test \
  			-t fi_FI -s en_XX \
  			--remove-bpe 'sentencepiece' \
  			--sacrebleu \
  			--langs $langs > $outdir/en_fi

		cat $outdir/en_fi | grep -P "^H" | sort -V | cut -f3- | sed 's/\[fi_FI\]//g' > $outdir/gen.out.detok.sys
		cat $outdir/en_fi | grep -P "^T" | sort -V | cut -f2- | sed 's/\[fi_FI\]//g' > $outdir/gen.out.detok.ref

		sacrebleu -tok 'none' -s 'none' $outdir/gen.out.detok.ref < $outdir/gen.out.detok.sys

		echo ""
	done
done

echo "Done."
