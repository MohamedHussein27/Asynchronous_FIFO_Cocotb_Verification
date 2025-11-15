module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    input W_CLK, // writing clock
    input W_RST,
    input [DATA_WIDTH-1:0] WR_DATA,
    input wclken, ren,// to control writing and reading
    input [$clog2(FIFO_DEPTH)-1:0] waddr, raddr,
    output [DATA_WIDTH-1:0] RD_DATA
);
    reg [$clog2(FIFO_DEPTH)-1:0] i;
    wire [$clog2(FIFO_DEPTH)-1:0] prev_addr; // to read the prev value in case of empty
    // memory
    reg [DATA_WIDTH-1:0] FIFO_mem [0:FIFO_DEPTH-1]; //the min depth should be 6 but i increased it by 2 as a safety margin
    // writing 
    always @(posedge W_CLK or negedge W_RST) begin
        if (!W_RST) begin
            for (i = 0; i < FIFO_DEPTH-1; i = i + 1) begin
                FIFO_mem[i] <= 0;
            end
            //FIFO_mem[7] <= 0;
        end
        else if (wclken) begin
            FIFO_mem[waddr] <= WR_DATA;
        end
    end
    // reading
    //assign prev_addr = !raddr ? raddr : raddr - 1; // if raddr is 0 then prev address is also 0
    //assign RD_DATA = ren ? FIFO_mem[raddr] : FIFO_mem[prev_addr];
    assign RD_DATA = FIFO_mem[raddr];
endmodule
