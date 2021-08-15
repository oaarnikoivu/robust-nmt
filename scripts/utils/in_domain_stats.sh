#!/bin/bash

src=en
tgt=fi 

size=$1
data=../../data/in_domain/$size 

en_file=$data/train.truecased.$src 
fi_file=$data/train.truecased.$tgt 

# Num. tokens and types  
echo "Number of English tokens: "
wc -w $en_file

echo "Number of English types: "
tr ' ' '\n' < $en_file | sort | uniq | wc -l

echo "Number of Finnish tokens: "
wc -w $fi_file

echo "Number of Finnish types:"
tr ' ' '\n' < $fi_file | sort | uniq | wc -l

# Average sentence length 
awk ' { thislen=length($0); printf("%-5s %d\n", NR, thislen); totlen+=thislen}
END { printf("average: %d\n", totlen/NR); } ' $fi_file
