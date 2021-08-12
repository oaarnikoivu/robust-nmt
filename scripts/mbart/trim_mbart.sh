#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

# e.g. bash trim_mbart.sh europarl_5k

size=$1

python trim_mbart.py \
    --pre-train-dir ./mbart.cc25 \
    --ft-dict $base/ft/$size/dict.txt \
    --langs ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN \
    --output $base/ft/$size/model.pt
