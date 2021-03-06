#!/bin/sh

script_dir=`dirname "$0"`
base=$script_dir/..
scripts=$base/scripts

mkdir -p $base/tools 

# Fairseq
echo "Cloning Fairseq github repository"
cd $base/tools && git clone https://github.com/pytorch/fairseq.git ./fairseq

cd ./fairseq 

pip install --editable .

#on MacOS:
# CFLAGS="-stdlib=libc++" pip3 install --editable ./

cd .. 

# subword-nmt
echo "Cloning Subword NMT repository (for BPE pre-processing)..."
cd $base/tools && git clone https://github.com/rsennrich/subword-nmt.git

echo "Done."

# Moses 
echo "Cloning Moses github repository (for tokenization scripts)..."
cd $base/tools && git clone https://github.com/moses-smt/mosesdecoder.git

# sacrebleu
pip install sacrebleu

# sacremoses
pip install sacremoses