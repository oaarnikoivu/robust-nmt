#!/bin/bash 

# e.g. bash shuffle_ood.sh mbart europarl_5k

system=$1
size=$2

for domain in law medical religion; do
    dir=./$system/out_domain/$size/$domain
    
    ref=$dir/gen.out.detok.ref
    sys=$dir/gen.out.detok.sys   

    paste -d ':' $ref $sys | shuf -n 100 | awk -v FS=":" '{ print $1 > "ref.shuffled" ; print $2 > "sys.shuffled" }'

    mv ref.shuffled $dir 
    mv sys.shuffled $dir
done 