`timescale 1ns / 1ps

module tb_soc;

    reg clk;
    reg resetn;
    reg [7:0] gpio_in;

    wire [7:0] gpio_out;
    wire pwm_out;
    wire uart_tx;

    soc dut (
        .clk(clk),
        .resetn(resetn),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out),
        .pwm_out(pwm_out),
        .uart_tx(uart_tx)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/soc.vcd");
        $dumpvars(0, tb_soc);

        clk = 0;
        resetn = 0;
        gpio_in = 8'hA5;

        #50;
        resetn = 1;

        #500;

        $finish;
    end

endmodule
