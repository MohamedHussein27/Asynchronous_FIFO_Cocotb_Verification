import cocotb
from cocotb.triggers import *


async def write_reset(dut, duration=50):
    """Apply reset to the write domain only"""
    dut.W_RST.value = 0
    dut.W_INC.value = 0
    dut.WR_DATA.value = 0
    await Timer(duration, units="ns")
    dut.W_RST.value = 1
    #await RisingEdge(dut.W_CLK)  # release aligned with write clock


async def read_reset(dut, duration=50):
    """Apply reset to the read domain only"""
    dut.R_RST.value = 0
    dut.R_INC.value = 0
    await Timer(duration, units="ns")
    dut.R_RST.value = 1
    #await RisingEdge(dut.R_CLK)  # release aligned with read clock
