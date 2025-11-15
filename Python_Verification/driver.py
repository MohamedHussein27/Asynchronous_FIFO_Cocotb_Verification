import cocotb
from cocotb.triggers import RisingEdge
from transaction import FifoTransaction

class FifoDriver:
    def __init__(self, dut):
        self.dut   = dut
        self.w_clk = dut.W_CLK
        self.r_clk = dut.R_CLK

    async def send(self, txn):
        """Drive transaction on DUT"""
        self.dut.W_INC.value = txn.wr_en
        self.dut.R_INC.value = txn.rd_en
        self.dut.WR_DATA.value = txn.wr_data

        # wait for specific clock according to the transaction type
        if (txn.wr_en):
            await RisingEdge(self.w_clk)
        elif (txn.rd_en):
            await RisingEdge(self.r_clk)
        else:
            await RisingEdge(self.r_clk)


