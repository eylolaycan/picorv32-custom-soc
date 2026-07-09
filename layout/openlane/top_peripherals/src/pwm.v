// rtl/pwm.v

module pwm (
    input  wire        clk,
    input  wire        resetn,
    input  wire        enable,
    input  wire [31:0] period,
    input  wire [31:0] duty,

    output reg         pwm_out
);

    reg [31:0] counter;

    always @(posedge clk) begin
        if (!resetn) begin
            counter <= 32'd0;
            pwm_out <= 1'b0;
        end else if (enable) begin
            if (counter >= period - 1) begin
                counter <= 32'd0;
            end else begin
                counter <= counter + 1;
            end

            if (counter < duty) begin
                pwm_out <= 1'b1;
            end else begin
                pwm_out <= 1'b0;
            end
        end else begin
            counter <= 32'd0;
            pwm_out <= 1'b0;
        end
    end

endmodule
