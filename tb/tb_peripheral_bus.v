`timescale 1ns / 1ps

module tb_peripheral_bus;

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

    task bus_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            force dut.mem_valid = 1'b1;
            force dut.mem_wstrb = 4'b1111;
            force dut.mem_addr  = addr;
            force dut.mem_wdata = data;
            #10;
            release dut.mem_valid;
            release dut.mem_wstrb;
            release dut.mem_addr;
            release dut.mem_wdata;
            #10;
        end
    endtask

    task bus_read;
        input [31:0] addr;
        begin
            force dut.mem_valid = 1'b1;
            force dut.mem_wstrb = 4'b0000;
            force dut.mem_addr  = addr;
            force dut.mem_wdata = 32'd0;
            #10;
            $display("READ addr=%h rdata=%h", addr, dut.mem_rdata);
            release dut.mem_valid;
            release dut.mem_wstrb;
            release dut.mem_addr;
            release dut.mem_wdata;
            #10;
        end
    endtask

    initial begin
        $dumpfile("sim/peripheral_bus.vcd");
        $dumpvars(0, tb_peripheral_bus);

        clk = 0;
        resetn = 0;
        gpio_in = 8'hA5;

        #50;
        resetn = 1;

        bus_write(32'h3000_0000, 32'h0000_0055);
        bus_read (32'h3000_0000);
        bus_read (32'h3000_0004);

        bus_write(32'h3000_0010, 32'd20);
        bus_write(32'h3000_0008, 32'd1);

        #100;
        bus_read(32'h3000_0014);

        bus_write(32'h3000_001C, 32'd10);
        bus_write(32'h3000_0020, 32'd4);
        bus_write(32'h3000_0018, 32'd1);

        #100;

        bus_write(32'h3000_0024, 32'h0000_00A5);

        #200;

        $finish;
    end

endmodule
