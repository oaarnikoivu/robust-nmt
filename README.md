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

### Distillation training

For distillation training to work with Fairseq, modify the <strong>TransformerDecoder> class under /tools/fairseq/fairseq/models/transformer.py:

```
def upgrade_state_dict_named(self, state_dict, name):
       # Keep the current weights for the decoder embedding table 
       for k in state_dict.keys():
           if 'decoder.embed_tokens' in k:
               state_dict[k] = self.embed_tokens.weight

       """Upgrade a (possibly old) state dict for new versions of fairseq."""
       if isinstance(self.embed_positions, SinusoidalPositionalEmbedding):
           weights_key = "{}.embed_positions.weights".format(name)
           if weights_key in state_dict:
               del state_dict[weights_key]
           state_dict[
               "{}.embed_positions._float_tensor".format(name)
           ] = torch.FloatTensor(1)

       if f"{name}.output_projection.weight" not in state_dict:
           if self.share_input_output_embed:
               embed_out_key = f"{name}.embed_tokens.weight"
           else:
               embed_out_key = f"{name}.embed_out"
           if embed_out_key in state_dict:
               state_dict[f"{name}.output_projection.weight"] = state_dict[
                   embed_out_key
               ]
               if not self.share_input_output_embed:
                   del state_dict[embed_out_key]

       for i in range(self.num_layers):
           # update layer norms
           layer_norm_map = {
               "0": "self_attn_layer_norm",
               "1": "encoder_attn_layer_norm",
               "2": "final_layer_norm",
           }
           for old, new in layer_norm_map.items():
               for m in ("weight", "bias"):
                   k = "{}.layers.{}.layer_norms.{}.{}".format(name, i, old, m)
                   if k in state_dict:
                       state_dict[
                           "{}.layers.{}.{}.{}".format(name, i, new, m)
                       ] = state_dict[k]
                       del state_dict[k]

       version_key = "{}.version".format(name)
       if utils.item(state_dict.get(version_key, torch.Tensor([1]))[0]) <= 2:
           # earlier checkpoints did not normalize after the stack of layers
           self.layer_norm = None
           self.normalize = False
           state_dict[version_key] = torch.Tensor([1])

       return state_dict
  ```



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
