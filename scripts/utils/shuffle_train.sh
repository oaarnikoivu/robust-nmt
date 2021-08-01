#!/bin/bash 

en_file=$1
fi_file=$2

paste -d ':' $en_file $fi_file | shuf | awk -v FS=":" '{ print $1 > "train.augmented.en" ; print $2 > "train.augmented.fi" }'