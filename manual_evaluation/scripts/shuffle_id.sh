#!/bin/bash 

# e.g. bash shuffle_id.sh baseline europarl_5k

system=$1
size=$2

dir=./$system/in_domain/$size

ref=$dir/gen.out.detok.ref
sys=$dir/gen.out.detok.sys

paste -d ':' $ref $sys | shuf -n 50 | awk -v FS=":" '{ print $1 > "ref.shuffled" ; print $2 > "sys.shuffled" }'

mv ref.shuffled $dir 
mv sys.shuffled $dir