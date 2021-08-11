#!/bin/bash

x=$1
y=$2 
z=$3 

python mean_bleu.py --scores $x $y $z
