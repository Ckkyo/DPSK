import numpy as np
VCO_N           =       (10)
VCO_PRECISE     =       (8-1)

BASE            =       2**VCO_N
x       = np.array(range(BASE))
y       = np.zeros(BASE)
for i in x:
    y[i] = int(int((2**VCO_PRECISE)*(np.sin(i*2*np.pi/(BASE)))))
h=hex(y[i])
np.savetxt("vco.txt", y, fmt='%x', delimiter='')