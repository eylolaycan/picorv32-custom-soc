// tb/tb_timer.v
`timescale 1ns / 1ps

module tb_timer;

    reg clk;
    reg resetn;
    reg enable;

    wire [31:0] counter;

    timer dut (
        .clk(clk),
        .resetn(resetn),
        .enable(enable),
        .counter(counter)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/timer.vcd");
        $dumpvars(0, tb_timer);

        clk = 0;
        resetn = 0;
        enable = 0;

        #20;
        resetn = 1;

        #20;
        enable = 1;

        #100;
        enable = 0;

        #40;
        enable = 1;

        #50;
        $finish;
    end

endmodule
