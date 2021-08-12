#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

# e.g. bash spm_tokenize.sh europarl_5k

set -m

size=$1

data=$base/mbart_data

spm=$base/tools/fairseq/scripts 

DATA=$data/in_domain/$size
OUTDIR=$base/ft/$size 

mkdir -p $OUTDIR

TRAIN=train 
VALID=dev 
TEST=test 

SRC=en_XX
TGT=fi_FI 

MODEL=../mbart.cc25/sentence.bpe.model

python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TRAIN}.${SRC} > ${OUTDIR}/${TRAIN}.spm.${SRC} &
python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TRAIN}.${TGT} > ${OUTDIR}/${TRAIN}.spm.${TGT} &
python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${VALID}.${SRC} > ${OUTDIR}/${VALID}.spm.${SRC} &
python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${VALID}.${TGT} > ${OUTDIR}/${VALID}.spm.${TGT} &
python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TEST}.${SRC} > ${OUTDIR}/${TEST}.spm.${SRC} &
python $spm/spm_encode.py --model=${MODEL} < ${DATA}/${TEST}.${TGT} > ${OUTDIR}/${TEST}.spm.${TGT} &
