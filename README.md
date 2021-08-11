# Robustness of Machine Translation for Low-Resource Languages 

This repository contains experimental code and scripts to reproduce the experiments for my master's thesis titled: "Robustness of Machine Translation for Low-Resource Languages". 

## Basic setup

### Install required librarires
 
    ./scripts/install_libraries.sh 


### Download data

    ./scripts/download_data.sh data

### Transformer preprocessing

#### Truecaser learned on full in-domain Europarl corpus

    ./scripts/transformer/preprocessing/truecase.sh
    
#### In-domain Byte Pair Encoding

    ./scripts/transformer/preprocessing/preprocess.sh [experiment name] [corpus size] [number of bpe merge operations]
    ./scripts/transformer/preprocessing/preprocess.sh europarl_5k_bpe_30000 europarl_5k 30000

#### Out-of-domain Byte Pair Encoding

    ./scripts/transformer/preprocessing/preprocess_ood.sh [experiment name] [corpus size] [domain]
    ./scripts/transformer/preprocessing/preprocess_ood.sh europarl_5k_bpe_30000 europarl_5k law
    ./scripts/transformer/preprocessing/preprocess_ood.sh europarl_5k_bpe_30000 europarl_5k medical
    ./scripts/transformer/preprocessing/preprocess_ood.sh europarl_5k_bpe_30000 europarl_5k religion
    
#### Binarize 

##### In-domain

    ./scripts/transformer/preprocessing/binarize_transformer.sh [experiment] [corpus size]
    ./scripts/transformer/preprocessing/binarize_transformer.sh europarl_5k_bpe_30000 europarl_5k
    
##### Out-of-domain

    ./scripts/transformer/preprocessing/binarize_transformer_ood.sh [experiment] [corpus size]
    ./scripts/transformer/preprocessing/binarize_transformer_ood.sh europarl_5k_bpe_30000 europarl_5k

### BPE-Dropout

#### Copy the training corpus l=64 times

    ./scripts/transformer/preprocessing/copy_corpus.sh [corpus size]
    ./scripts/transformer/preprocessing/copy_corpus.sh europarl_5k
    
#### Apply BPE-Dropout with p = 0.1

    ./scripts/transformer/preprocessing/preprocess_bpe_dropout.sh [experiment name] [corpus size]
    ./scripts/transformer/preprocessing/preprocess_bpe_dropout.sh europarl_5k_bpe_30000 europarl_5k

#### Binarize BPE-Dropout 

##### In-domain
    
    ./scripts/transformer/preprocessing/binarize_bpe_dropout.sh [experiment] [corpus size]
    ./scripts/transformer/preprocessing/binarize_bpe_dropout.sh europarl_5k_bpe_30000 europarl_5k

##### Out-of-domain
    
    ./scripts/transformer/preprocessing/binarize_bpe_dropout_ood.sh [experiment] [corpus size]
    ./scripts/transformer/preprocessing/binarize_bpe_dropout_ood.sh europarl_5k_bpe_30000 europarl_5k
    
## Transformer Training
To train an indivudal model, see scripts under scripts/transformer/training

## Transformer Evaluation
To evaluate an individual model, see scripts under scripts/transformer/evaluation

### Distillation
For distillation to work, first you must have trained a Transformer on one of the europarl subsets following the steps above.

To generate a distilled training set, see scripts/transformer/translate
