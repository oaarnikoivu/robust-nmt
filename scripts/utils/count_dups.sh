#!/bin/bash

size=$1
domain=$2

data=../../data/in_domain/$size/
ood=../../data/out_domain/$domain

train_file=$data/train.truecased.en
test_file=$data/test.truecased.en
dev_file=$data/dev.truecased.en

echo "Number of duplicates between train and train for $size: "
sort $train_file | uniq -c | wc -l

echo "Number of duplicates between train and test for $size: "
awk 'FNR==NR{lines[$0]=1;next} $0 in lines' $train_file $test_file | wc -l

echo "Number of duplicates between train and dev for $size: "
awk 'FNR==NR{lines[$0]=1;next} $0 in lines' $train_file $dev_file | wc -l

echo "Number of duplicates between test and dev for $size: "
awk 'FNR==NR{lines[$0]=1;next} $0 in lines' $test_file $dev_file | wc -l
