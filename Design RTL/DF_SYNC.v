module df_sync #(
    parameter FIFO_DEPTH = 8
) (
    input clk,
    input rst,
    input [$clog2(FIFO_DEPTH):0] ptr_in,
    output reg [$clog2(FIFO_DEPTH):0] ptr_out
);
    reg [$clog2(FIFO_DEPTH):0] ptr_intermediate;
    // two flip-flops for synchronizing the pointer from one clock domain to another
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ptr_intermediate <= 0;
            ptr_out <= 0;
        end
        else begin
            ptr_intermediate <= ptr_in;
            ptr_out <= ptr_intermediate;
        end
    end
endmodule