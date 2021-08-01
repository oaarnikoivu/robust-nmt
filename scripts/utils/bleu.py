import argparse
import numpy as np


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--scores", type=float, nargs="+", help="BLEU scores for each model", required=True)
    args = parser.parse_args()
    return args


def bleu(x, y, z):
    score = np.array([x, y, z])
    return np.mean(score), np.std(score)


def main():
    args = parse_args()
    x, y, z = args.scores 
    print(bleu(x, y, z))


if __name__ == "__main__":
    main()
