`timescale 1ns/1ps

module tb_gpio;

reg clk;
reg resetn;
reg valid;
reg write;
reg [31:0] wdata;
wire [31:0] rdata;
wire ready;
wire [7:0] gpio_out;

gpio dut (
    .clk(clk),
    .resetn(resetn),
    .valid(valid),
    .write(write),
    .wdata(wdata),
    .rdata(rdata),
    .ready(ready),
    .gpio_out(gpio_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    resetn = 0;
    valid = 0;
    write = 0;
    wdata = 32'h00000000;

    #20;
    resetn = 1;

    #10;
    valid = 1;
    write = 1;
    wdata = 32'h000000A5;

    #10;
    valid = 0;
    write = 0;

    #20;

    if (gpio_out == 8'hA5)
        $display("PASS: GPIO output is correct.");
    else
        $display("FAIL: GPIO output is %h", gpio_out);

    #20;
    $finish;
end

initial begin
    $dumpfile("tb_gpio.vcd");
    $dumpvars(0, tb_gpio);
end

endmodule
