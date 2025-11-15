# Set simulator
SIM ?= icarus   # Change to questa, vcs, modelsim, verilator, etc.

# Set language
TOPLEVEL_LANG ?= verilog

# Path to design sources
PWD := $(shell pwd)
VERILOG_SOURCES := \
    $(PWD)/ASYNCHRONOUS_FIFO.v \
    $(PWD)/DF_SYNC.v \
    $(PWD)/FIFO_MEM_CNTRL.v \
    $(PWD)/FIFO_RD.v \
    $(PWD)/FIFO_WR.v

# Top-level design module
TOPLEVEL := asynch_fifo   # DUT module name (must match your Verilog top)

# Python testbench module (test_<dut>.py → test_<dut>)
MODULE := asynchronous_fifo_test   # Name of your Python test file without .py

# Cocotb include
include $(shell cocotb-config --makefiles)/Makefile.sim
