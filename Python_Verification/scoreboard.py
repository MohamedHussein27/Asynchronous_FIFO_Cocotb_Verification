import cocotb
from cocotb.triggers import *


class FifoScoreboard:
    def __init__(self, dut):
        self.dut = dut
        self.errors = 0
        self.checks = 0

    async def check_data(self):
        """Check if RD_DATA matches expected FIFO memory (raddr or prev_addr)."""
        await RisingEdge(self.dut.R_CLK)  # equivalent to #20 in your Verilog

        rd_data = int(self.dut.RD_DATA.value)
        raddr = int(self.dut.fifo_memory.raddr.value)
        #prev_addr = int(self.dut.fifo_memory.prev_addr.value)

        mem = self.dut.fifo_memory.FIFO_mem  # accessing memory array

        expected_rdata = int(mem[raddr].value)
        #expected_prev = int(mem[prev_addr].value)

        self.checks += 1

        if rd_data != expected_rdata:
            cocotb.log.error(f"Data mismatch! Expected (raddr={raddr}→{expected_raddr:#x} "
                             f"or prev_addr={prev_addr}→{expected_prev:#x}), "
                             f"but got RD_DATA={rd_data:#x}")
            self.errors += 1
        else:
            #if rd_data == expected_prev:
                #cocotb.log.info(f"Data match! WR_DATA was {expected_prev:#x}, RD_DATA={rd_data:#x}")
            #else:
            cocotb.log.info(f"Data match! WR_DATA was {expected_raddr:#x}, RD_DATA={rd_data:#x}")
