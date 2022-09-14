import matlab
import matlab.engine
import numpy as np
import init
"""
fir模块应该只创建滤波器而不指定滤波行为
"""

def fir_low_coeff(sample_hz,pass_hz,stop_hz):
    #
    eng     = init._get_engine()
    print(type(sample_hz))
    fir_coeff  = np.array(list(eng.low_pass(\
        matlab.double([sample_hz]),\
            matlab.double([pass_hz]),\
                matlab.double([stop_hz]))))
    #fir_coeff   = eng.low_pass()
    return     fir_coeff

#def fir_low_tap_num(eng,sample_hz,pass_hz,stop_hz,order = 0):
#    return int(sample_hz/pass_hz)









