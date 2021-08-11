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
