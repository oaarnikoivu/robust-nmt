#!/bin/bash 

# e.g. bash eval_ood_transformer.sh europarl_5k_bpe_10000 europarl_5k

script_dir=`dirname "$0"`
base=$script_dir/../../..
scripts=$base/scripts

src=en
tgt=fi

experiment=$1
size=$2

for domain in law medical religion; do 
    bin_dir=$base/test-bin/$domain/$experiment/$src-$tgt
    
    for seed in 1 2 3; do
        echo "Evaluating the $domain domain at seed $seed:"

        # If evaluating the baseline change "transformer_optim" to "transformer_baseline" below! 
        #checkpoint_dir=$base/checkpoints/transformer_optim/$experiment/$seed 
        #result_dir=$base/translations/transformer_optim/$size/$seed/$domain 

        checkpoint_dir=$base/checkpoints/transformer_baseline/$experiment/$seed 
        result_dir=$base/translations/transformer_baseline/$size/$seed/$domain 


        fairseq-generate $bin_dir \
            --source-lang $src --target-lang $tgt \
            --path $checkpoint_dir/checkpoint_best.pt \
            --beam 5 \
            --remove-bpe \
            --sacrebleu \
            --results-path $result_dir

        grep ^H $result_dir/generate-test.txt | cut -f3- | sacremoses detruecase | sacremoses detokenize > $result_dir/gen.out.detok.sys
        grep ^T $result_dir/generate-test.txt | cut -f2- | sacremoses detruecase | sacremoses detokenize > $result_dir/gen.out.detok.ref

        # Evaluate against reference using sacreBLEU
        cat $result_dir/gen.out.detok.sys | sacrebleu $result_dir/gen.out.detok.ref

        echo ""
    done
done 

echo "Done."
