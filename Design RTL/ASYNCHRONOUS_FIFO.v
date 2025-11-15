module asynch_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input W_CLK, W_RST, W_INC, R_CLK, R_RST, R_INC,
    input [DATA_WIDTH-1:0] WR_DATA,
    output FULL, EMPTY,
    output [DATA_WIDTH-1:0] RD_DATA
);
    wire [$clog2(FIFO_DEPTH):0] wptr, rptr, wq2_rptr, wq2_wptr;
    wire [$clog2(FIFO_DEPTH)-1:0] waddr, raddr;
    wire wclken, ren;

    fifo_wr #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) fifo_write (
        .W_CLK(W_CLK),
        .W_RST(W_RST),
        .W_INC(W_INC),
        .wq2_rptr(wq2_rptr),
        .FULL(FULL),
        .waddr(waddr),
        .wptr(wptr)
    );

    fifo_rd #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) fifo_read (
        .R_CLK(R_CLK),
        .R_RST(R_RST),
        .R_INC(R_INC),
        .wq2_wptr(wq2_wptr),
        .EMPTY(EMPTY),
        .raddr(raddr),
        .rptr(rptr)
    );
    // combinational logic to make the enable for the fifo memory
    assign wclken = W_INC && !FULL;
    assign ren    = R_INC && !EMPTY;

    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) fifo_memory (
        .W_CLK(W_CLK),
        .W_RST(W_RST),
        .WR_DATA(WR_DATA),
        .wclken(wclken),
        .ren(ren),
        .waddr(waddr),
        .raddr(raddr),
        .RD_DATA(RD_DATA)
    );

    df_sync #(
        .FIFO_DEPTH(FIFO_DEPTH)
    ) df_sync_write (
        .clk(W_CLK),
        .rst(W_RST),
        .ptr_in(rptr),
        .ptr_out(wq2_rptr)
    );

    df_sync #(
        .FIFO_DEPTH(FIFO_DEPTH)
    ) df_sync_read (
        .clk(R_CLK),
        .rst(R_RST),
        .ptr_in(wptr),
        .ptr_out(wq2_wptr)
    );
    initial begin
    	$dumpfile("dump.vcd");
    	$dumpvars(0, asynch_fifo);
    end
endmodule
