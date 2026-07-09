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

        #100;
        resetn = 1;

        #2000;

        $display("gpio_out = %h", gpio_out);

        if (gpio_out == 8'h55)
            $display("TEST PASSED: firmware wrote GPIO_OUT");
        else
            $display("TEST FAILED: GPIO_OUT is not 0x55");

        $finish;
    end

endmodule
