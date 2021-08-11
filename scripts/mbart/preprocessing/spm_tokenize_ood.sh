#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

set -m

SRC=en_XX
TGT=fi_FI

data=$base/data 

spm=$base/tools/fairseq/scripts

MODEL=./mbart.cc25/sentence.bpe.model

for domain in law medical religion; do
	echo "Tokenizing for the $domain domain:"
	
	DATA=$data/out_domain/$domain
	OUTDIR=$base/ft/$domain
	
	mkdir -p $OUTDIR
	
	# Deduplicate ood test set
	test_src_file=$DATA/test.$SRC
	test_tgt_file=$DATA/test.$TGT
	
	paste $test_src_file $test_tgt_file | awk '!x[$0]++' > $DATA/test.dedup
	
	cut -f1 $DATA/test.dedup > $DATA/test.deduped.$SRC
	cut -f2 $DATA/test.dedup > $DATA/test.deduped.$TGT
	
	TEST=test.deduped
	
	python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TEST}.${SRC} > ${OUTDIR}/${TEST}.spm.${SRC} &
	python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TEST}.${TGT} > ${OUTDIR}/${TEST}.spm.${TGT} &
	
	echo ""
done 

echo "Done."