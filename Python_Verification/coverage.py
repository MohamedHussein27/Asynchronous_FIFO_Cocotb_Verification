import cocotb
from cocotb_coverage.coverage import *

@coverage_section
class FifoCoverage:
    def __init__(self, dut):
        self.dut = dut

    @CoverPoint(
        "fifo.write_trans",
        xf=lambda txn: txn.wr_en,
        bins=[0, 1],
        bins_labels=["write_disabled", "write_enabled"]
    )
    @CoverPoint(
        "fifo.read_trans",
        xf=lambda txn: txn.rd_en,
        bins=[0, 1],
        bins_labels=["read_disabled", "read_enabled"]
    )
    @CoverPoint(
        "fifo.full_flag",
        xf=lambda txn: txn.full,
        bins=[0, 1],
        bins_labels=["not_full", "full"]
    )
    @CoverPoint(
        "fifo.empty_flag",
        xf=lambda txn: txn.empty,
        bins=[0, 1],
        bins_labels=["not_empty", "empty"]
    )
    def sample_coverage(self, txn):
        """Sample coverage using the given transaction object."""
        pass  # decorators handle sampling automatically

    def report(self, filename="coverage_report.txt"):
        """Generate a coverage report (console + file)."""
        log = cocotb.logging.getLogger("cocotb.test")
        print("\n==== FIFO Coverage Report ====")
        coverage_db.report_coverage(log.info, bins=True)
        coverage_db.export_to_xml(filename="coverage_fifo.xml")
        print(f"[INFO] Coverage report saved to {filename}")