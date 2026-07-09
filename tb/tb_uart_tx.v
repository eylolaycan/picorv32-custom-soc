// tb/tb_uart_tx.v

`timescale 1ns / 1ps

module tb_uart_tx;

    reg clk;
    reg resetn;
    reg start;
    reg [7:0] data;

    wire tx;
    wire busy;

    uart_tx dut (
        .clk(clk),
        .resetn(resetn),
        .start(start),
        .data(data),
        .tx(tx),
        .busy(busy)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        clk = 0;
        resetn = 0;
        start = 0;
        data = 8'h00;

        #20;
        resetn = 1;

        #20;
        data = 8'hA5;
        start = 1;

        #10;
        start = 0;

        #150;

        data = 8'h3C;
        start = 1;

        #10;
        start = 0;

        #150;

        $finish;
    end

endmodule
