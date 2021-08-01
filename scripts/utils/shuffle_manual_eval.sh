#!/bin/bash 

ref=$1 
sys=$2

paste -d ':' $ref $sys | shuf | awk -v FS=":" '{ print $1 > "ref.shuffled" ; print $2 > "sys.shuffled" }'
