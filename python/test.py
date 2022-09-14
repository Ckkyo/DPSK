import numpy as np 
import matlab
import matlab.engine
eng       = matlab.engine.start_matlab()
a = eng.untitled()
print(a)
print(dir(a))

