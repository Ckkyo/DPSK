#global lib
import numpy as np
import matplotlib.pyplot as plt
import matlab
import matlab.engine

#usr lib
import init

import map

import frame

import mod

import fir

import costas
#define
byte        = 8
head_size   = 8 * byte
data_size   = 120 * byte

carr_defreq = 0
carr_hz_real= 4000 + carr_defreq   #载波真实频率
carr_hz     = 4000  #载波目标频率
info_hz     = 200

sample_ratio= 8     #采样是载波目标频率的几倍
sample_hz   = carr_hz * sample_ratio

ref_bit     = 1

isshow      = 1
#matlab引擎
eng         = init._init_engine()


#code





rng             = np.random.RandomState(2)

#生成初始帧
frame_origin    = frame.Frame(head_size,data_size,rng)
frame_origin.special_head_div(1)
frame_origin.rand_data()
#暂时数据全0就好   frame_origin.rand_data()

#生成map后的帧
frame_map           = frame.Frame(head_size,data_size,rng)
frame_map.put_frame(np.delete(map.map_diff(frame_origin.frame,1),0))

#生成已调波
#暂时只使用帧头  moder           = mod.Mod(frame_map.frame,info_hz,carr_hz_real,sample_hz)
moder           = mod.Mod(frame_map.frame,info_hz,carr_hz_real,sample_hz)
moder.dpsk()
signal_send    = moder.moded

#以随机的相位得到已调波（模拟数据发送时间的随机性）
    #fai在二分之一码元之内
rand_fai        = rng.randint(sample_hz/(2*info_hz))
rand_fai        = 40
signal_receive  = np.concatenate((np.zeros(rand_fai),signal_send[rand_fai:]))

#利用costas提取载波
cost            = costas.Coctas(signal_receive,carr_hz,sample_hz)
cost_carr       = cost.run()
pout            = cost.pout
signal_demoded  = cost.demoded

#test
print('self.pcir_ave : ',cost.pcir_ave,'  with real feq = ',carr_hz_real)



x_frame         = range(head_size+data_size)
if(isshow):
    plt.figure('frame')
    plt.plot(x_frame,frame_origin.frame,label='origin')
    plt.plot(x_frame,frame_map.frame   ,label='map   ')
    plt.show(block=False)



    plt.figure('moded signal and costas_carrier')


    plt.plot(range(np.size(signal_receive)),signal_receive   ,label='signal_receive   ',)
    #plt.plot(range(np.size(signal_send)),signal_send   ,'ro',label='signal_send   ',)
    plt.plot(range(np.size(cost_carr)),cost_carr   ,label='cost_carr   ',)
    plt.plot(range(np.size(pout)),pout   ,label='pout   ',)
    plt.show(block=False)
    plt.figure()
    plt.plot(range(np.size(pout)),cost.fai2-moder.get_phase(),label='cost.fai2   ',)
    plt.plot(range(np.size(pout)),cost.pcirout   ,label='cost.pcirout   ',)
    plt.show(block=False)

    plt.figure('demoded')
    plt.plot(range(np.size(signal_demoded)),signal_demoded   ,label='signal_demoded   ',)
    plt.show()












