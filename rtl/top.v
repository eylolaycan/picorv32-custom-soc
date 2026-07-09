module top (
    input  wire        clk,
    input  wire        resetn,

    output wire [7:0]  gpio_out
);

wire        mem_valid;
wire        mem_instr;
wire        mem_ready;
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [3:0]  mem_wstrb;
wire [31:0] mem_rdata;

wire gpio_sel = mem_valid && (mem_addr[31:28] == 4'h3);

picorv32 #(
    .ENABLE_COUNTERS(0),
    .ENABLE_COUNTERS64(0),
    .ENABLE_REGS_16_31(1),
    .ENABLE_REGS_DUALPORT(1),
    .TWO_STAGE_SHIFT(1),
    .BARREL_SHIFTER(0),
    .COMPRESSED_ISA(0),
    .ENABLE_MUL(0),
    .ENABLE_DIV(0),
    .ENABLE_IRQ(0),
    .ENABLE_TRACE(0)
) cpu (
    .clk(clk),
    .resetn(resetn),

    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata)
);

gpio gpio0 (
    .clk(clk),
    .resetn(resetn),

    .valid(gpio_sel),
    .write(|mem_wstrb),
    .wdata(mem_wdata),
    .rdata(mem_rdata),
    .ready(mem_ready),

    .gpio_out(gpio_out)
);

endmodule
