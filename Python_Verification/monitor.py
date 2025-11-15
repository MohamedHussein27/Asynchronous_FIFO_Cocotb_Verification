import cocotb
from cocotb.triggers import RisingEdge
from transaction import FifoTransaction

class FifoMonitor:
    def __init__(self, dut, callback_cov=None, callback_sb=None):
        self.dut = dut
        self.callback_cov = callback_cov
        self.callback_sb = callback_sb

    async def observe(self):
        while True:
            await RisingEdge(self.dut.R_CLK)
            txn = FifoTransaction(self.dut)
            txn.wr_en = int(self.dut.W_INC.value)
            txn.rd_en = int(self.dut.R_INC.value)
            txn.wr_data = int(self.dut.WR_DATA.value)
            txn.full = int(self.dut.FULL.value)
            txn.empty = int(self.dut.EMPTY.value)
            txn.rd_data = int(self.dut.RD_DATA.value)
            if self.callback_cov:
                self.callback_cov(txn)
            #check the scoreboard only if it's a read transaction
            if (self.callback_sb and txn.rd_en):
                self.callback_sb()
