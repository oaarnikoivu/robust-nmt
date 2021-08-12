#!/bin/bash 

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

# e.g. bash build_vocab.sh europarl_5k

size=$1

python build_vocab.py \
    --corpus-data "${base}/ft/${size}/*.spm.*" \
    --langs ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN \
    --output ${base}/ft/${size}/dict.txt
