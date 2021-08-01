#!/bin/bash

src=en
tgt=fi 

domain=$1
data=../data/out_domain/$domain

en_file=$data/test.truecased.$src 
fi_file=$data/test.truecased.$tgt 

echo "Word-level stats for the ${domain} domain:"
echo ""

# Num. tokens and types  
echo "Number of English tokens: "
wc -w $en_file

echo "Number of English types: "
tr ' ' '\n' < $en_file | sort | uniq | wc -l

echo "Number of Finnish tokens: "
wc -w $fi_file

echo "Number of Finnish types:"
tr ' ' '\n' < $fi_file | sort | uniq | wc -l
