module fifo_wr #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8
) (
    input W_INC, W_CLK, W_RST,
    input [$clog2(FIFO_DEPTH):0] wq2_rptr, // read pointer after the synchronizer
    output FULL, // fifo is full
    output reg [$clog2(FIFO_DEPTH)-1:0] waddr, // gray-coded
    output [$clog2(FIFO_DEPTH):0] wptr // write pointer has a wider width than write address by one bit
);

    reg [$clog2(FIFO_DEPTH):0] wptr_non_grayed;
    always @(posedge W_CLK or negedge W_RST) begin
        if (!W_RST) begin
            waddr <= 0;
            wptr_non_grayed <= 0;
        end
        /*else if (waddr == FIFO_DEPTH - 1) begin
            waddr <= 0;
            wptr_non_grayed <= wptr_non_grayed + 1;
        end*/
        else if (W_INC && !FULL) begin
            waddr <= waddr + 1;
            wptr_non_grayed <= wptr_non_grayed + 1;
        end
    end
    // gray coding: gray = binary ^ (binary>>1)
    assign wptr = wptr_non_grayed ^ (wptr_non_grayed>>1);
    // full flag
    assign FULL = ((wptr[$clog2(FIFO_DEPTH)] != wq2_rptr[$clog2(FIFO_DEPTH)]) && 
                   (wptr[$clog2(FIFO_DEPTH)-1] != wq2_rptr[$clog2(FIFO_DEPTH)-1]) &&
                   (wptr[$clog2(FIFO_DEPTH)-2:0] == wq2_rptr[$clog2(FIFO_DEPTH)-2:0]));
endmodule