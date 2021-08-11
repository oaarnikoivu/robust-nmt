import numpy as np 

def get_prop_hallucination(fluent, partially_fluent, not_fluent, adequate, partially_adequate, inadequate):    
    adequate_and_fluent = adequate + partially_adequate + fluent + partially_fluent
    adequate_and_not_fluent = adequate + partially_adequate + not_fluent
    inadequate_and_fluent = inadequate + fluent + partially_fluent
    inadequate_and_not_fluent = inadequate + not_fluent

    total = 100

    hallucination = inadequate_and_fluent / total 

    return hallucination

print(get_prop_hallucination(5, 13, 7, 5, 6, 17))

