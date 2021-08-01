#!/bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

tgt=fi

moses_scripts=$base/tools/mosesdecoder/scripts

sed -r 's/\@\@ //g' |
$moses_scripts/recaser/detruecase.perl |
$moses_scripts/tokenizer/detokenizer.perl -l $tgt
