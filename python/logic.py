import numpy as np
def xor(a,b):
    if(a==b):
        return 0
    else:
        return 1

def xor_arr(a,b):
    if(np.size(a)!=np.size(b)):
        print('element numbers of a and b is not eq')
        return '产生赋值报错'
    temp = np.zeros(np.size(a))
    for i in range(np.size(a)):
        temp[i]     = xor(a[i],b[i])












