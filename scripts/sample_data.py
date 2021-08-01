import random
import os 
import sys
import numpy as np 

DATA_PATH = sys.argv[1]

FULL = DATA_PATH + '/in_domain/full/'
EUROPARL = DATA_PATH + '/in_domain/europarl/'
EUROPARL_5k = DATA_PATH + '/in_domain/europarl_5k/'
EUROPARL_10k = DATA_PATH + '/in_domain/europarl_10k/'
EUROPARL_20k = DATA_PATH + '/in_domain/europarl_20k/'
EUROPARL_40k = DATA_PATH + '/in_domain/europarl_40k/'
EUROPARL_80k = DATA_PATH + '/in_domain/europarl_80k/'

LAW = DATA_PATH + '/out_domain/law/'
MEDICAL = DATA_PATH + '/out_domain/medical/'
RELIGION = DATA_PATH + '/out_domain/religion/'

EUROPARL_FI = EUROPARL + 'Europarl.en-fi.fi'
EUROPARL_EN = EUROPARL + 'Europarl.en-fi.en'

LAW_FI = LAW + 'JRC-Acquis.en-fi.fi'
LAW_EN = LAW + 'JRC-Acquis.en-fi.en'

MEDICAL_FI = MEDICAL + 'EMEA.en-fi.fi'
MEDICAL_EN = MEDICAL + 'EMEA.en-fi.en'

RELIGION_FI = RELIGION + 'bible-uedin.en-fi.fi'
RELIGION_EN = RELIGION + 'bible-uedin.en-fi.en'

DEV_TEST_PATH = DATA_PATH + '/in_domain/'

def add_data(lang):
    data = []
    if isinstance(lang, list):
        for line in lang:
            data.append(line)
    else:
        with open(lang, 'r') as f:
            for line in f:
                data.append(line)
    return data

def select_subset(l1, l2, amount):
    d1 = add_data(lang=l1)
    d2 = add_data(lang=l2)
    d = list(zip(d1, d2))
    random.shuffle(d)
    x, y = zip(*d)
    return list(x[:amount]), list(y[:amount])

def write_to_file(data, datapath, filepath):
    with open(datapath + filepath, 'w') as f:
        for d in data:
            f.write(f'{d}')
    f.close()

corpus_fi, corpus_en = select_subset(EUROPARL_FI, EUROPARL_EN, amount=164000)

# Use first 160,000 as full training corpus
train_fi_full, train_en_full = corpus_fi[:160000], corpus_en[:160000]
write_to_file(train_fi_full, EUROPARL, 'train.fi')
write_to_file(train_en_full, EUROPARL, 'train.en')

write_to_file(train_fi_full, FULL, 'train.fi')
write_to_file(train_en_full, FULL, 'train.en')

# Use remaining 4000 and dev and test sets split evenly 
dev_fi, dev_en = corpus_fi[160000:162000], corpus_en[160000:162000]
test_fi, test_en = corpus_fi[162000:164000], corpus_en[162000:164000]

write_to_file(dev_fi, EUROPARL, 'dev.fi')
write_to_file(dev_en, EUROPARL, 'dev.en')
write_to_file(test_fi, EUROPARL, 'test.fi')
write_to_file(test_en, EUROPARL, 'test.en')

train_fi_5k, train_en_5k = select_subset(train_fi_full, train_en_full, amount=5000)
write_to_file(train_fi_5k, EUROPARL_5k, 'train.fi')
write_to_file(train_en_5k, EUROPARL_5k, 'train.en')
write_to_file(dev_fi, EUROPARL_5k, 'dev.fi')
write_to_file(dev_en, EUROPARL_5k, 'dev.en')
write_to_file(test_fi, EUROPARL_5k, 'test.fi')
write_to_file(test_en, EUROPARL_5k, 'test.en')

train_fi_10k, train_en_10k = select_subset(train_fi_full, train_en_full, amount=10000)
write_to_file(train_fi_10k, EUROPARL_10k, 'train.fi')
write_to_file(train_en_10k, EUROPARL_10k, 'train.en')
write_to_file(dev_fi, EUROPARL_10k, 'dev.fi')
write_to_file(dev_en, EUROPARL_10k, 'dev.en')
write_to_file(test_fi, EUROPARL_10k, 'test.fi')
write_to_file(test_en, EUROPARL_10k, 'test.en')

train_fi_20k, train_en_20k = select_subset(train_fi_full, train_en_full, amount=20000)
write_to_file(train_fi_20k, EUROPARL_20k, 'train.fi')
write_to_file(train_en_20k, EUROPARL_20k, 'train.en')
write_to_file(dev_fi, EUROPARL_20k, 'dev.fi')
write_to_file(dev_en, EUROPARL_20k, 'dev.en')
write_to_file(test_fi, EUROPARL_20k, 'test.fi')
write_to_file(test_en, EUROPARL_20k, 'test.en')

train_fi_40k, train_en_40k = select_subset(train_fi_full, train_en_full, amount=40000)
write_to_file(train_fi_40k, EUROPARL_40k, 'train.fi')
write_to_file(train_en_40k, EUROPARL_40k, 'train.en')
write_to_file(dev_fi, EUROPARL_40k, 'dev.fi')
write_to_file(dev_en, EUROPARL_40k, 'dev.en')
write_to_file(test_fi, EUROPARL_40k, 'test.fi')
write_to_file(test_en, EUROPARL_40k, 'test.en')

train_fi_80k, train_en_80k = select_subset(train_fi_full, train_en_full, amount=80000)
write_to_file(train_fi_80k, EUROPARL_80k, 'train.fi')
write_to_file(train_en_80k, EUROPARL_80k, 'train.en')
write_to_file(dev_fi, EUROPARL_80k, 'dev.fi')
write_to_file(dev_en, EUROPARL_80k, 'dev.en')
write_to_file(test_fi, EUROPARL_80k, 'test.fi')
write_to_file(test_en, EUROPARL_80k, 'test.en')

# Create out of domain test sets 
law_fi, law_en = select_subset(LAW_FI, LAW_EN, amount=2000)
write_to_file(law_fi, LAW, 'test.fi')
write_to_file(law_en, LAW, 'test.en')

medical_fi, medical_en = select_subset(MEDICAL_FI, MEDICAL_EN, amount=2000)
write_to_file(medical_fi, MEDICAL, 'test.fi')
write_to_file(medical_en, MEDICAL, 'test.en')

religion_fi, religion_en = select_subset(RELIGION_FI, RELIGION_EN, amount=2000)
write_to_file(religion_fi, RELIGION, 'test.fi')
write_to_file(religion_en, RELIGION, 'test.en')
