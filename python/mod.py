import numpy as np

class Mod():

    def __init__(self,info,info_hz,carr_hz,sample_hz):
        self.info       = info
        self.info_hz    = info_hz 
        self.carr_hz    = carr_hz
        self.sample_hz  = sample_hz
        

        #已调波采样总数
        self.num        = int(np.size(self.info) *self.sample_hz/self.info_hz)# -1,不需要减一
        self.moded      = np.zeros(self.num)
        self.carr_phase = np.zeros(self.num)


    def dpsk(self):
        #将info变成1，-1
        for i in range(np.size(self.info)):
            self.info[i]    = 1 if self.info[i] > 0 else -1
        for n in range(self.num):
            self.moded[n]   = self.info[int((n*self.info_hz)/(self.sample_hz))]*\
                np.cos((2*np.pi*n*self.carr_hz)/self.sample_hz)
            #self.moded[n]   =     np.cos((2*np.pi*n*self.carr_hz)/self.sample_hz)
    def get_phase(self):
        for n in range(self.num):
            self.carr_phase[n]= ((2*np.pi*n*self.carr_hz)/self.sample_hz)%(2*np.pi)
        return self.carr_phase
            