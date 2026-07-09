module simple_ram (
    input  wire        clk,
    input  wire        valid,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,

    output reg  [31:0] rdata
);

    reg [31:0] mem [0:255];

    wire [7:0] word_addr;
    assign word_addr = addr[9:2];

    initial begin
        $readmemh("firmware/main.hex", mem);
    end

    always @(posedge clk) begin
        if (valid) begin
            if (wstrb[0]) mem[word_addr][7:0]   <= wdata[7:0];
            if (wstrb[1]) mem[word_addr][15:8]  <= wdata[15:8];
            if (wstrb[2]) mem[word_addr][23:16] <= wdata[23:16];
            if (wstrb[3]) mem[word_addr][31:24] <= wdata[31:24];

            rdata <= mem[word_addr];
        end
    end

endmodule
