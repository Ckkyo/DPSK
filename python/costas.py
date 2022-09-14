import numpy as np
from fir import *

class Coctas():

    def __init__(self,signal,des_hz,sample_hz):
        self.signal     = signal
        self.des_hz     = des_hz
        self.sample_hz  = sample_hz

        #滤波器参数
        self.lpf_pass   = int(des_hz * 0.125)
        self.lpf_stop   = int(des_hz * 0.875)
        self.lpf_coeff  = fir_low_coeff(sample_hz,self.lpf_pass,self.lpf_stop)
        self.lpf_tap    = np.size(self.lpf_coeff)
        print('lpf_tap   =',self.lpf_tap)

        self.cir_pass   = int(des_hz * 0.1)
        self.cir_stop   = int(des_hz * 0.5)
        #self.cir_coeff  = fir_low_coeff(sample_hz,self.cir_pass,self.cir_stop)
        self.cir_coeff  = np.ones(int(sample_hz/self.cir_pass))
        self.cir_tap    = np.size(self.cir_coeff)
            #用于滤波器的移位寄存器
        self.reg_lpf_i      = np.zeros(self.lpf_tap)
        self.reg_lpf_q      = np.zeros(self.lpf_tap)
        self.reg_cir        = np.zeros(self.cir_tap)

        #控制生成vco的精细度以及步长，即默认地址每次加step，在不够精准的情况下地址每次加step - 1 或者 step + 1
        #调整速度
        self.N          = 10
        self.step       = 2**self.N
        self.fai        = 0
        #vco N=int(step*fs/fc)
        self.period_vco = int((2**self.N) *  sample_hz / des_hz)
        self.vco        = np.cos(2*np.pi*np.array(range(self.period_vco))/self.period_vco+1.4)

        #各级信号
        self.p          = 0
        self.pcir       = 0
        self.vo         = 0
        self.ci         = 0
        self.i          = 0
        self.ilpf       = 0
        self.cq         = 0
        self.q          = 0
        self.qlpf       = 0 

        self.C1         = ((2**self.N)/((4*np.pi))/5)
        self.C2         = ((2**self.N)/((4*np.pi))/400)
        self.lfai       = 0.1
        self.p_pre      = 0
        self.dstep      = 0

        self.fai2   = np.zeros(np.size(self.signal))



        self.vout        = np.zeros(np.size(self.signal))
        self.pout       = np.zeros(np.size(self.signal))
        self.pcirout    = np.zeros(np.size(self.signal))
        self.demoded     = np.zeros(np.size(self.signal))
    #运行滤波器，计算一次数值
    def lpf_i_run_(self):
        self.reg_lpf_i  = np.delete(self.reg_lpf_i,0)
        self.reg_lpf_i  = np.concatenate((self.reg_lpf_i,np.array([self.i])))
        return np.sum(np.multiply(self.reg_lpf_i,self.lpf_coeff))
    def lpf_q_run_(self):
        self.reg_lpf_q  = np.delete(self.reg_lpf_q,0)
        self.reg_lpf_q  = np.concatenate((self.reg_lpf_q,np.array([self.q])))
        return np.sum(np.multiply(self.reg_lpf_q,self.lpf_coeff))
    def lpf_i_run(self,n):
        temp_k          = 0
        temp_n          = 0
        temp_i          = np.zeros(self.lpf_tap)
        for m in range(self.lpf_tap):
            temp_n      = (n-m)%self.period_vco
            temp_k      = (self.n-(self.N**2)*m)%self.period_vco
            temp_i[m]   = self.signal[temp_n]*self.vco[temp_k]
        return np.sum(np.multiply(temp_i,self.lpf_coeff))
    def lpf_q_run(self,n):
        temp_k          = 0
        temp_n          = 0
        temp_q          = np.zeros(self.lpf_tap)
        for m in range(self.lpf_tap):
            temp_n      = (n-m)%self.period_vco
            temp_k      = (self.n-(self.N**2)*m)%self.period_vco
            temp_q[m]   = self.signal[temp_n]*self.vco[temp_k]
        return np.sum(np.multiply(temp_q,self.lpf_coeff))
    def cir_run(self):
        self.lfai       =self.lfai + self.C2*self.p
        return int(self.lfai + self.C1*self.p)

    def run(self):
        #单周期模型,将vco看做一级存储器，其他都为组合逻辑，因此vco的控制逻辑k为变化的最后一级
        self.n               = 0
        self.nq              = self.n + int(self.period_vco/4)
        for n in range(np.size(self.signal)):
            #调控self.n和self.nq保证不会超过数组上限，在fpga中无需此操作
            self.n       = self.n%self.period_vco
            self.nq      = (self.n + int(self.period_vco/4))%self.period_vco



            self.vo     = self.vco[(self.n+self.fai)%self.period_vco]
            self.vout[n]= self.vo

            self.ci     = self.vco[self.n]
            self.i      = self.signal[n]*self.ci

            self.cq     = self.vco[(self.nq+self.fai)%self.period_vco]
            self.q      = self.signal[n]*self.cq

            self.ilpf   = self.lpf_i_run_()
            self.qlpf   = self.lpf_q_run_()
            self.p_pre  =self.p
            
            self.p      = (self.ilpf * (self.qlpf))
            self.pcir  = self.cir_run()
            
            if(self.dstep!=self.pcir):
                print(self.step+self.dstep)
            
            self.dstep = self.pcir
            self.demoded[n]= self.ilpf
            #self.pout[n]= self.pcir
            self.pout[n] = self.p
            self.pcirout[n]= self.pcir
            self.fai2[n]= (2*np.pi*int((self.n+(2.8/np.pi)*self.period_vco)%(self.period_vco))/self.period_vco)
            self.n      = self.step+self.n+self.dstep

        self.pcir_ave   =np.sum(self.pout)/np.size(self.pout)

        return self.vout
            
               


            







 
