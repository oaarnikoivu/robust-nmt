import os 
import sys 
import re

OOD_PATH = sys.argv[1]

LAW = OOD_PATH + '/law/'
MEDICAL = OOD_PATH + '/medical/'
RELIGION = OOD_PATH + '/religion/'

OUT = OOD_PATH + '/ood/'
ADEQUACY = OUT + '/adequacy/'
FLUENCY = OUT  + '/fluency/'


def contains_just_number(s):
    return bool(re.match('^\d+\.$', s)) or bool(re.match('^[-+]?[0-9]+$', s)) or bool(re.match('^[a-zA-Z0-9]\.+$', s)) or bool(re.match('^\d+\. "$', s))


def sample_from_ood(sys_file, ref_file, amount):
    sys, ref = [], [] 

    with open(sys_file) as f1, open(ref_file) as f2:
        for s, r in zip(f1, f2):
            if not contains_just_number(s):
                sys.append(s)
                ref.append(r)

    return sys[:amount], ref[:amount]


def write_to_file(data, datapath, filepath):
    with open(datapath + filepath, 'w') as f:
        for d in data:
            f.write(f'{d}')
    f.close()

law_sys, law_ref = sample_from_ood(LAW + 'sys.shuffled', LAW + 'ref.shuffled', amount=8)
medical_sys, medical_ref = sample_from_ood(MEDICAL + 'sys.shuffled', MEDICAL + 'ref.shuffled', amount=8)
religion_sys, religion_ref = sample_from_ood(RELIGION + 'sys.shuffled', RELIGION + 'ref.shuffled', amount=9)

sys = law_sys + medical_sys + religion_sys 
ref = law_ref + medical_ref + religion_ref 

write_to_file(sys, ADEQUACY, "sys.mixed")
write_to_file(sys, FLUENCY, "sys.mixed")
write_to_file(ref, OUT, "ref.mixed")
