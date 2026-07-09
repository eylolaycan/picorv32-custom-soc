module timer (
    input wire clk,
    input wire resetn,
    input wire enable,
    input wire clear,
    input wire [31:0] compare,

    output reg [31:0] counter,
    output reg irq
);

always @(posedge clk) begin

    if (!resetn) begin
        counter <= 32'd0;
        irq <= 1'b0;
    end

    else if (clear) begin
        counter <= 32'd0;
        irq <= 1'b0;
    end

    else if (enable) begin
        counter <= counter + 1;

        if (counter >= compare)
            irq <= 1'b1;
    end

end

endmodule
