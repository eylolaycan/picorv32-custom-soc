// rtl/uart_tx.v

module uart_tx (
    input  wire       clk,
    input  wire       resetn,
    input  wire       start,
    input  wire [7:0] data,

    output reg        tx,
    output reg        busy
);

    reg [3:0] bit_index;
    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_index <= 4'd0;
            shift_reg <= 10'b1111111111;
        end else begin

            if (start && !busy) begin
                shift_reg <= {1'b1, data, 1'b0};
                busy      <= 1'b1;
                bit_index <= 4'd0;
            end else if (busy) begin
                tx        <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                bit_index <= bit_index + 1'b1;

                if (bit_index == 4'd9) begin
                    busy <= 1'b0;
                end
            end else begin
                tx <= 1'b1;
            end

        end
    end

endmodule
