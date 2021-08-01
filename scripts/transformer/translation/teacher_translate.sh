#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

size=$1
experiment=$2

# Path to best model checkpoint achieved by optimized Transformer 
checkpoint_dir=$3

data=$base/data 

fairseq_dir=$base/tools/fairseq/fairseq_cli
bin_dir=$base/data-bin/$experiment/$src-$tgt

train_data_src=$data/in_domain/$size/$experiment/bpe/bpe.train.truecased.$src
dev_data_src=$data/in_domain/$size/$experiment/bpe/bpe.dev.truecased.$src

result_dir=$base/translations/distillation/teacher/$experiment

mkdir -p $result_dir

echo "Translating training data..."

# Translate train
fairseq-generate $bin_dir \
	--path $checkpoint_dir/checkpoint_best.pt \
	--gen-subset train \
	--batch-size 64 \
	--beam 5 \
	--results-path $result_dir/train

echo ""
echo "Translating validation data..."

# Translate dev
fairseq-generate $bin_dir \
	--path $checkpoint_dir/checkpoint_best.pt \
	--gen-subset valid \
	--batch-size 64 \
	--beam 5 \
	--results-path $result_dir/dev

echo ""
echo "Extracting translations and source..." 

# Extract translations and source to maintain alignment since generate re-orders the data 
grep ^H $result_dir/train/generate-train.txt | cut -f3- > $result_dir/bpe.train.distilled.$tgt
grep ^S $result_dir/train/generate-train.txt | cut -f2- > $result_dir/bpe.train.distilled.$src

grep ^H $result_dir/dev/generate-valid.txt | cut -f3- > $result_dir/bpe.dev.distilled.$tgt
grep ^S $result_dir/dev/generate-valid.txt | cut -f2- > $result_dir/bpe.dev.distilled.$src
