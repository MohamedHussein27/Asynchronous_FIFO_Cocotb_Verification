import random

class FifoTransaction:
    def __init__(self, dut, data_width=8):
        self.dut = dut
        self.data_width = data_width
        self.wr_en = 0
        self.rd_en = 0
        self.wr_data = 0
        self.full = 0
        self.empty = 0
        self.rd_data = 0 

    async def randomize(self): 
        # Randomize write/read enables
        # Weighted Randomization for Read Enable (Read more often than not)
        # Weights: [0, 1] -> [30, 70] means 70% chance of read_en=1
        self.rd_en = random.choices([0, 1], weights=[30, 70], k=1)[0]
        
        # Weighted Randomization for Write Enable (Write less often than read)
        # Weights: [0, 1] -> [70, 30] means 30% chance of wr_en=1
        self.wr_en = random.choices([0, 1], weights=[70, 30], k=1)[0]
        # Randomize input data only if write enabled
        if self.wr_en:
            self.wr_data = random.randint(0, (1 << self.data_width) - 1)
        return self
    
    async def direct(self, w_flag, r_flag): 
        self.wr_en = w_flag
        self.rd_en = r_flag
        # Randomize input data only if write enabled
        if self.wr_en:
            self.wr_data = random.randint(0, (1 << self.data_width) - 1)
        return self

    def __repr__(self):
        return f"Txn(wr_en={self.wr_en}, rd_en={self.rd_en}, wr_data={self.wr_data})"

