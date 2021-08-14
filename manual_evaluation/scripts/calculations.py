import sys
import numpy as np 

size = sys.argv[1]
system = sys.argv[2]

adequacy_file = f"/Users/olive/github/msc-thesis/manual_evaluation/{system}/out_domain/{size}/ood/adequacy/sys.mixed"
fluency_file = f"/Users/olive/github/msc-thesis/manual_evaluation/{system}/out_domain/{size}/ood/fluency/sys.mixed"

# adequacy_file = f"/Users/olive/github/msc-thesis/manual_evaluation/{system}/in_domain/{size}/adequacy/sys.shuffled"
# fluency_file = f"/Users/olive/github/msc-thesis/manual_evaluation/{system}/in_domain/{size}/fluency/sys.shuffled"

# proprotion of hallucinations
def get_hallucinations(a_file, f_file):
    num_hallucinations = 0
    total = 25

    with open(a_file) as f1, open(f_file) as f2:
        for s1, s2 in zip(f1, f2):
            if '-> 0' in s1 and '-> 1' in s2 or '-> 0' in s1 and '-> 2' in s2:
                num_hallucinations += 1
    
    return num_hallucinations / total 

# proportion of at least partially fluent and at least partially adequate
def get_partials(a_file, f_file):
    num_pfs = 0
    num_pas = 0
    total = 25

    with open(a_file) as f1, open(f_file) as f2:
        for s1, s2 in zip(f1, f2):
            if '-> 1' in s2 or '-> 2' in s2:
                num_pfs += 1
            if '-> 1' in s1 or '-> 2' in s1:
                num_pas += 1

    return (num_pfs / total, num_pas / total)

# from the at least partially fluent translations, which domains do they come from? 
def get_domain_props(f_file):
    files = []

    law = 0
    medical = 0
    religion = 0

    with open(f_file) as f:
        for s in f:
            files.append(s)
        
    for s in files[:8]:
        if '-> 1' in s or '-> 2' in s:
            law += 1 
    
    for s in files[8:16]:
        if '-> 1' in s or '-> 2' in s:
            medical += 1
    
    for s in files[16:]:
        if '-> 1' in s or '-> 2' in s:
            religion += 1

    total = (law + medical + religion)

    return {
        'law': round(law / total, 2),
        'medical': round(medical / total, 2),
        'religion': round(religion / total, 2)
    }
