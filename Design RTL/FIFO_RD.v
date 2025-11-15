module fifo_rd #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8
) (
    input R_INC, R_CLK, R_RST,
    input [$clog2(FIFO_DEPTH):0] wq2_wptr, // write pointer after the synchronizer
    output EMPTY, // fifo is EMPTY
    output [$clog2(FIFO_DEPTH):0] rptr, // gray-coded
    output reg [$clog2(FIFO_DEPTH)-1:0] raddr
);
    reg [$clog2(FIFO_DEPTH):0] rptr_non_grayed;
    always @(posedge R_CLK or negedge R_RST) begin
        if (!R_RST) begin
            raddr <= 0;
            rptr_non_grayed <= 0;
        end
        /*else if (raddr == FIFO_DEPTH - 1) begin
            raddr <= 0;
            rptr_non_grayed <= rptr_non_grayed + 1;
        end*/
        else if (R_INC && !EMPTY) begin
            raddr <= raddr + 1;
            rptr_non_grayed <= rptr_non_grayed + 1;
        end
    end
    // gray coding: gray = binary ^ (binary>>1)
    assign rptr = rptr_non_grayed ^ (rptr_non_grayed>>1);
    // FIFO EMPTY flag
    assign EMPTY = (rptr == wq2_wptr);

endmodule