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
    
    e.g. ./scripts/transformer/preprocessing/preprocess.sh europarl_5k_bpe_30000 europarl_5k 30000

#### Out-of-domain Byte Pair Encoding

    ./scripts/transformer/preprocessing/preprocess_ood.sh [experiment name] [corpus size] [domain]
    
#### Binarize 

##### In-domain

    ./scripts/transformer/preprocessing/binarize_transformer.sh [experiment] [corpus size]
    
##### Out-of-domain

    ./scripts/transformer/preprocessing/binarize_transformer_ood.sh [experiment] [corpus size]

### BPE-Dropout

#### Copy the training corpus l=64 times

    ./scripts/transformer/preprocessing/copy_corpus.sh [corpus size]
    ./scripts/transformer/preprocessing/copy_corpus.sh europarl_5k
    
#### Apply BPE-Dropout with p = 0.1

    ./scripts/transformer/preprocessing/preprocess_bpe_dropout.sh [experiment name] [corpus size]

#### Binarize BPE-Dropout 

##### In-domain
    
    ./scripts/transformer/preprocessing/binarize_bpe_dropout.sh [experiment] [corpus size]

##### Out-of-domain
    
    ./scripts/transformer/preprocessing/binarize_bpe_dropout_ood.sh [experiment] [corpus size]
     
## Transformer Training and Evaluation
To train an indivudal model, see scripts under scripts/transformer/training

To evaluate an individual model, see scripts under scripts/transformer/evaluation

Find example slurm scripts for training under scripts/transformer/training/slurm

Find example slurm scripts for evaluation under scripts/transformer/evaluation/slurm

## Distillation
For distillation to work, first you must have trained a Transformer on one of the europarl subsets following the steps above.

To generate a distilled training set, see scripts/transformer/translate

To prepare distilled training set for the student network: 

    ./scripts/transformer/preprocessing/binarize_distillation.sh [experiment name] [corpus size]
    
    ./scripts/transformer/preprocessing/binarize_distillation_ood.sh [experiment name] [corpus size]

To train the student network, see scripts under scripts/transformer/training

To evaluate the student network, see scripts under scripts/transformer/evaluation

## mBART25

### Installing the pretrained model

    ./scripts/mbart/get_pretrained_model.sh

### Tokenization

    ./scripts/mbart/preprocessing/spm_tokenize.sh [corpus size]
    
    ./scripts/mbart/preprocessing/spm_tokenize_ood.sh
    
### Build new dictionary 

    ./scripts/mbart/build_vocab.sh [corpus size]

### Prune the pre-trained model

    ./scripts/mbart/trim_mbart.sh

### Binarize

    ./scripts/mbart/preprocessing/binarize.sh [corpus size]
    
    ./scripts/mbart/preprocessing/binarize_ood.sh [corpus size
        
### Training and Evaluation
For fine-tuning mBART25, see /scripts/mbart/finetune.sh

For evaluating mBART25, see /scripts/mbart/eval.sh and /scripts/mbart/eval_ood.sh

Find example slurm scripts for training and evaluation in /scripts/mbart/slurm

## RNN

### Build network dictionaries

    ./scripts/rnn/jsonify.sh [experiment name] [corpus size]
    
### Training and Evaluation
See /scripts/rnn/train.sh and /scripts/rnn/translate.sh

Find example slurm scripts for training and evaluation in /scripts/rnn/slurm
