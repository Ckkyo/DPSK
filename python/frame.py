import numpy as np
import map
import logic
class Frame():

    def __init__(self,head_size,data_size,rng):
        self.head_size  = head_size
        self.data_size  = data_size
        self.frame_size = head_size + data_size
        self.rng        = rng
        self.head       = np.zeros(head_size)
        self.data       = np.zeros(data_size)
        self.frame      = np.concatenate((self.head,self.data))
    
    #随机化数据
    def rand_data(self):
        self.data       = self.rng.randint(2,size=self.data_size)
        self.frame      = np.concatenate((self.head,self.data))


    #div之前为0101的帧头
    def special_head(self):
        return 0

    #div之后为0，1交替的帧头,可以根据参考位0则给出div后10101010的帧头，参考位1则给出010101
    def special_head_div(self,ref_bit):
        b_diff    = np.concatenate((np.array([ref_bit]),np.zeros(self.head_size)))
        for i in range(self.head_size):
            b_diff[i+1]     = logic.xor(1,b_diff[i])
        self.head = map.map_diff_inv(b_diff)
        self.frame      = np.concatenate((self.head,self.data))

    def put_frame(self,frame):
        self.frame  = frame
        self.head   = frame[:self.head_size]
        self.data   = frame[self.head_size:]
    def put_data(self,data):
        self.data   = data
        self.frame  = np.concatenate((self.head,self.data))
    def put_head(self,head):
        self.head   = head 
        self.frame  = np.concatenate((self.head,self.data))

    def copy(self,temp):
        self.head       = temp.head
        self.data       = temp.data
        self.frame      = temp.frame

""""
使用这种帧头在差分之后可以得到010101的序列
test    = np.array([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
test_diff   = map.map_diff(test,first=1)
print(test_diff)

test_diff =np.array([0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0])
test        =map.map_diff_inv(test_diff)
print(test)

"""










