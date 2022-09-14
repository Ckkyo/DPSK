import numpy as np
import logic
#输出b_origin的差分序列,包括参考位
def map_diff(b_origin,ref_bit = 0):
    if (ref_bit != 0 and ref_bit != 1):
        print("please constrain ref_bit = 0 or fist = 1")

    length_b_diff   = np.size(b_origin) + 1
    b_diff          = np.array(range(0,length_b_diff))
    b_diff[0]       = ref_bit 

    for i in range(length_b_diff - 1):
            b_diff[i+1]   = logic.xor(b_diff[i],b_origin[i])
    return b_diff

#输出差分的逆，默认参考值包含在b_diff中
def map_diff_inv(b_diff):
    b_origin_size   = np.size(b_diff)-1
    b_origin        = np.zeros(b_origin_size)
    for i in range(b_origin_size):
        b_origin[i] = logic.xor(b_diff[i+1],b_diff[i])
    return b_origin