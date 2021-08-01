#!/bin/bash

x=$1
y=$2 
z=$3 

python bleu.py --scores $x $y $z
