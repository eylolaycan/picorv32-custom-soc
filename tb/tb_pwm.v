// tb/tb_pwm.v

`timescale 1ns / 1ps

module tb_pwm;

    reg clk;
    reg resetn;
    reg enable;
    reg [31:0] period;
    reg [31:0] duty;

    wire pwm_out;

    pwm dut (
        .clk(clk),
        .resetn(resetn),
        .enable(enable),
        .period(period),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/pwm.vcd");
        $dumpvars(0, tb_pwm);

        clk = 0;
        resetn = 0;
        enable = 0;
        period = 32'd10;
        duty = 32'd3;

        #20;
        resetn = 1;

        #20;
        enable = 1;

        #200;

        duty = 32'd7;

        #200;

        enable = 0;

        #50;

        $finish;
    end

endmodule
