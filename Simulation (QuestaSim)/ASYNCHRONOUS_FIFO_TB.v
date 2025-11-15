`timescale 1ns / 1ps
module asynch_fifo_tb ();
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;
    reg W_CLK, W_RST, W_INC, R_CLK, R_RST, R_INC;
    reg [DATA_WIDTH-1:0] WR_DATA;
    wire FULL, EMPTY;
    wire [DATA_WIDTH-1:0] RD_DATA;
    

    asynch_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uut (
        .W_CLK(W_CLK),
        .W_RST(W_RST),
        .W_INC(W_INC),
        .R_CLK(R_CLK),
        .R_RST(R_RST),
        .R_INC(R_INC),
        .WR_DATA(WR_DATA),
        .FULL(FULL),
        .EMPTY(EMPTY),
        .RD_DATA(RD_DATA)
    );

    integer j,k;

    // generating write clock
    initial begin
        W_CLK = 0;
        forever #5 W_CLK = ~W_CLK; // 100 MHZ clock
    end
    // generating read clock
    initial begin
        R_CLK = 0;
        forever #12.5 R_CLK = ~R_CLK; // 40 MHZ clock
    end
    
    // write stimulus
    initial begin
        // task for write reset
        write_reset();
        infering_data(1); // (write enable) only write enabled, random data
        infering_data(1);
        infering_data(1);
        infering_data(0);
        #150; // waiting until reading is done
        // testing full
        for(j = 0; j < FIFO_DEPTH ; j = j + 1) begin
            infering_data(1);
        end
        infering_data(0);
    end

    // read stimulus
    initial begin
        // task for read reset
        read_reset();
        reading_data(1); // (read enable) only read enabled
        check_data(); // always check data after reading
        reading_data(1);
        check_data();
        reading_data(1);
        check_data();
        #50;
        reading_data(0);
        #250;
        // testing empty
        for(k = 0; k < FIFO_DEPTH ; k = k + 1) begin
            reading_data(1);
            check_data();
        end
        #50;
        reading_data(0);
        #100;
    end

    // writing and reading at the same time to check no overflow will happen if we transmit the 9 bytes along
    // writing
    initial begin
        #1000; // time till the prev tests finish
        for(j = 0; j < 9 ; j = j + 1) begin
            infering_data(1);    
        end
        infering_data(0);
    end
    // reading
    initial begin
        #1000; // time till the prev tests finish
        for(k = 0; k < 9 ; k = k + 1) begin
            reading_data(1);
            check_data();
        end
        reading_data(0);
        #200;
    end

    // writing and reading at the same time to check no overflow will happen if we keep transmitting bytes along
    // writing
    initial begin
        #1400; // time till the prev tests finish
        for(j = 0; j < 40 ; j = j + 1) begin
            infering_data(1);    
        end
        infering_data(0);
    end
    // reading
    initial begin
        #1400; // time till the prev tests finish
        for(k = 0; k < 40 ; k = k + 1) begin
            reading_data(1);
            check_data();
        end
        reading_data(0);
        #200;
        $stop;
    end


    //************************ tasks *********************\\
    // writing reset
    task write_reset();
    begin
        W_RST = 0;
        #10 W_RST = 1; // releasing write reset
    end
    endtask

    // reading reset
    task read_reset();
    begin
        R_RST = 0;
        #25 R_RST = 1; // releasing read reset
    end
    endtask

    // infering data
    task infering_data(input w_enable);
    begin
        W_INC = w_enable;
        WR_DATA = $random;
        #10; // wait one write clock period
    end
    endtask

    // reading data
    task reading_data(input r_enable);
    begin
        R_INC = r_enable;
    end
    endtask

    // checking data matching after reading
    task check_data();
    begin
        #5;
        if (RD_DATA !== uut.fifo_memory.FIFO_mem[uut.raddr] && RD_DATA !== uut.fifo_memory.FIFO_mem[uut.fifo_memory.prev_addr]) begin
            $display("Data mismatch! WR_DATA was : %h, RD_DATA: %h", uut.fifo_memory.FIFO_mem[uut.raddr], RD_DATA);
        end
        else begin
            if (RD_DATA === uut.fifo_memory.FIFO_mem[uut.fifo_memory.prev_addr])
                $display("Data match! WR_DATA was : %h, RD_DATA: %h", uut.fifo_memory.FIFO_mem[uut.fifo_memory.prev_addr], RD_DATA);
            else
                $display("Data match! WR_DATA was : %h, RD_DATA: %h", uut.fifo_memory.FIFO_mem[uut.raddr], RD_DATA);
        end
        #20; // wait one read clock period
    end
    endtask
endmodule