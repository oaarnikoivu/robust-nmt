#!bin/bash 

corpus=europarl

for size in europarl_5k europarl_10k europarl_20k europarl_40k europarl_80k europarl; do 
    for system in baseline transformer rnn mbart bpe_dropout distillation; do
        echo "Computing partials for $system at $size:"
        python calculations.py $size $system 
        echo ""
    done 
done 