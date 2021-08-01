#!/bin/sh

# Fairseq
echo "Cloning Fairseq github repository"
git clone https://github.com/pytorch/fairseq.git ./fairseq

cd ./fairseq 

pip install --editable .

#on MacOS:
# CFLAGS="-stdlib=libc++" pip3 install --editable ./

cd .. 

# subword-nmt
echo "Cloning Subword NMT repository (for BPE pre-processing)..."
git clone https://github.com/rsennrich/subword-nmt.git

echo "Done."

# Moses 
echo "Cloning Moses github repository (for tokenization scripts)..."
git clone https://github.com/moses-smt/mosesdecoder.git

# sacrebleu
pip install sacrebleu

# sacremoses
pip install sacremoses


# Make sure to move necessary libraries run scripts to the tools directory! 
