import numpy as np
import matplotlib.pyplot as plt

y_moded = np.loadtxt("moded.txt")
y_demoded   = np.loadtxt("i_lpfed.txt")
plt.figure("y_moded")
plt.plot(y_moded)
plt.show(block=False)


plt.figure("y_demoded")
plt.plot(y_demoded)

plt.show() 