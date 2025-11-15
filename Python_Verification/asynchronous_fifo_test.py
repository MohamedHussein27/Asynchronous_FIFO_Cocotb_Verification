import cocotb
from cocotb.clock import Clock
from cocotb.triggers import *

from driver import FifoDriver
from monitor import FifoMonitor
from scoreboard import FifoScoreboard
from coverage import FifoCoverage
from transaction import FifoTransaction
from reset import write_reset, read_reset

import random


async def reset_dut(dut):
    """Reset DUT signals directly (no interface)."""
    dut.W_RST.value = 0
    dut.R_RST.value = 0
    dut.W_INC.value = 0
    dut.R_INC.value = 0
    dut.WR_DATA.value = 0
    await Timer(20, units="ns")
    dut.W_RST.value = 1
    dut.R_RST.value = 1
    await RisingEdge(dut.W_CLK)
    await RisingEdge(dut.R_CLK)
    cocotb.log.info(" Reset complete.")


@cocotb.test()
async def async_fifo_test(dut):
    """Test asynchronous FIFO with directed + random transactions"""

    # clocks
    cocotb.start_soon(Clock(dut.W_CLK, 10, units="ns").start())   # 100 MHz
    cocotb.start_soon(Clock(dut.R_CLK, 25, units="ns").start())   # 40 MHz

    # reset tasks
    write_reset_task = cocotb.start_soon(write_reset(dut, duration=5))
    read_reset_task = cocotb.start_soon(read_reset(dut, duration=12.5))
    await Combine(write_reset_task, read_reset_task)

    # components
    driver = FifoDriver(dut)
    scoreboard = FifoScoreboard(dut)
    coverage = FifoCoverage(dut)

    # to sample cover points
    def callback_cov(txn):
        # Sample coverage when monitor captures a transaction
        coverage.sample_coverage(txn)

    # to compare the value of RD_data with the value written in the memory
    def callback_sb():
        scoreboard.check_data()

    monitor = FifoMonitor(dut, callback_cov, callback_sb)
    cocotb.start_soon(monitor.observe())

    data_width = dut.WR_DATA.value.n_bits
    # transaction
    txn = FifoTransaction(dut)

    # directed stimulus: fill FIFO
    for _ in range(16):
        await txn.direct(1,0)  # txn.direct(1,0) indicates a writing process without reading
        await FallingEdge(dut.W_CLK)  # Wait for a falling clock edge
        await driver.send(txn)

    # directed stimulus: empty FIFO
    for _ in range(16):
        await txn.direct(0,1) # txn.direct(1,0) indicates a reading process without writing
        await FallingEdge(dut.R_CLK)  # Wait for a falling clock edge
        await driver.send(txn)
    
    # wait for two clocks to seperate tests
    dut.R_INC.value = 0
    dut.W_INC.value = 0
    
    
    # directed stimulus: Writing the 9 bytes while reading at the same time
    for _ in range(9):
        await txn.direct(1,1)
        await FallingEdge(dut.W_CLK)  # Wait for a falling clock edge
        await driver.send(txn)
    
    dut.R_INC.value = 0
    dut.W_INC.value = 0
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    
    #reset the FIFO 
    write_reset_task = cocotb.start_soon(write_reset(dut, duration=5))
    read_reset_task = cocotb.start_soon(read_reset(dut, duration=12.5))
    await Combine(write_reset_task, read_reset_task)
    
    # directed stimulus: Writing and reading at the same time to determine when the overflow happens (full flag arises but we are still transmitting)
    for _ in range(40):
        await txn.direct(1,1)
        await FallingEdge(dut.W_CLK)  # Wait for a falling clock edge
        await driver.send(txn)
    
    
    dut.R_INC.value = 0
    dut.W_INC.value = 0
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    
    
    #reset the FIFO 
    write_reset_task = cocotb.start_soon(write_reset(dut, duration=5))
    read_reset_task = cocotb.start_soon(read_reset(dut, duration=12.5))
    await Combine(write_reset_task, read_reset_task)
    
    # random stimulus:
    for _ in range(40):
        await txn.randomize()
        if dut.W_INC.value and dut.R_INC.value:
            await FallingEdge(dut.R_CLK)        
        elif dut.W_INC.value:
            await FallingEdge(dut.W_CLK)
        elif dut.R_INC.value:
            await FallingEdge(dut.R_CLK)
        else:
            await FallingEdge(dut.R_CLK)
        await driver.send(txn) 

    # End of simulation
    dut.R_INC.value = 0
    dut.W_INC.value = 0
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)
    await FallingEdge(dut.R_CLK)

    # final checks
    coverage.report()
    assert scoreboard.errors == 0, f"Scoreboard found {scoreboard.errors} mismatches!"
    cocotb.log.info("Asynchronous FIFO test PASSED")
