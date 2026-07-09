// rtl/soc.v
module soc (
    input  wire clk,
    input  wire resetn,

    input  wire [7:0] gpio_in,
    output wire [7:0] gpio_out,

    output wire pwm_out,
    output wire uart_tx
);

    localparam GPIO_OUT_ADDR      = 32'h3000_0000;
    localparam GPIO_IN_ADDR       = 32'h3000_0004;
    localparam TIMER_ENABLE_ADDR  = 32'h3000_0008;
    localparam TIMER_CLEAR_ADDR   = 32'h3000_000C;
    localparam TIMER_COMPARE_ADDR = 32'h3000_0010;
    localparam TIMER_COUNT_ADDR   = 32'h3000_0014;
    localparam PWM_ENABLE_ADDR    = 32'h3000_0018;
    localparam PWM_PERIOD_ADDR    = 32'h3000_001C;
    localparam PWM_DUTY_ADDR      = 32'h3000_0020;
    localparam UART_DATA_ADDR     = 32'h3000_0024;

    wire        mem_valid;
    wire        mem_instr;
    reg         mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;

    wire mem_write = mem_valid && (mem_wstrb != 4'b0000);
    wire mem_read  = mem_valid && (mem_wstrb == 4'b0000);

    wire mem_is_ram        = (mem_addr[31:28] == 4'h0);
    wire mem_is_peripheral = (mem_addr[31:28] == 4'h3);

    wire [31:0] ram_rdata;

    reg [7:0] gpio_reg;

    reg        timer_enable;
    reg        timer_clear;
    reg [31:0] timer_compare;
    wire [31:0] timer_counter;
    wire        timer_irq;

    reg        pwm_enable;
    reg [31:0] pwm_period;
    reg [31:0] pwm_duty;

    reg        uart_start;
    reg [7:0]  uart_data;
    wire       uart_busy;

    assign gpio_out = gpio_reg;

    picorv32 cpu (
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

    simple_ram u_ram (
        .clk(clk),
        .valid(mem_valid && mem_is_ram),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .wstrb(mem_wstrb),
        .rdata(ram_rdata)
    );

    timer u_timer (
        .clk(clk),
        .resetn(resetn),
        .enable(timer_enable),
        .clear(timer_clear),
        .compare(timer_compare),
        .counter(timer_counter),
        .irq(timer_irq)
    );

    pwm u_pwm (
        .clk(clk),
        .resetn(resetn),
        .enable(pwm_enable),
        .period(pwm_period),
        .duty(pwm_duty),
        .pwm_out(pwm_out)
    );

    uart_tx u_uart_tx (
        .clk(clk),
        .resetn(resetn),
        .start(uart_start),
        .data(uart_data),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    always @(posedge clk) begin
        if (!resetn) begin
            gpio_reg      <= 8'd0;

            timer_enable  <= 1'b0;
            timer_clear   <= 1'b0;
            timer_compare <= 32'd10;

            pwm_enable    <= 1'b0;
            pwm_period    <= 32'd10;
            pwm_duty      <= 32'd3;

            uart_start    <= 1'b0;
            uart_data     <= 8'd0;
        end else begin
            timer_clear <= 1'b0;
            uart_start  <= 1'b0;

            if (mem_write && mem_is_peripheral) begin
                case (mem_addr)
                    GPIO_OUT_ADDR: begin
                        gpio_reg <= mem_wdata[7:0];
                    end

                    TIMER_ENABLE_ADDR: begin
                        timer_enable <= mem_wdata[0];
                    end

                    TIMER_CLEAR_ADDR: begin
                        timer_clear <= mem_wdata[0];
                    end

                    TIMER_COMPARE_ADDR: begin
                        timer_compare <= mem_wdata;
                    end

                    PWM_ENABLE_ADDR: begin
                        pwm_enable <= mem_wdata[0];
                    end

                    PWM_PERIOD_ADDR: begin
                        pwm_period <= mem_wdata;
                    end

                    PWM_DUTY_ADDR: begin
                        pwm_duty <= mem_wdata;
                    end

                    UART_DATA_ADDR: begin
                        uart_data  <= mem_wdata[7:0];
                        uart_start <= 1'b1;
                    end

                    default: begin
                    end
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            mem_ready <= 1'b0;
            mem_rdata <= 32'd0;
        end else begin
            mem_ready <= mem_valid;

            if (mem_is_ram) begin
                mem_rdata <= ram_rdata;
            end else if (mem_read && mem_is_peripheral) begin
                case (mem_addr)
                    GPIO_OUT_ADDR:      mem_rdata <= {24'd0, gpio_reg};
                    GPIO_IN_ADDR:       mem_rdata <= {24'd0, gpio_in};
                    TIMER_ENABLE_ADDR:  mem_rdata <= {31'd0, timer_enable};
                    TIMER_COMPARE_ADDR: mem_rdata <= timer_compare;
                    TIMER_COUNT_ADDR:   mem_rdata <= timer_counter;
                    PWM_ENABLE_ADDR:    mem_rdata <= {31'd0, pwm_enable};
                    PWM_PERIOD_ADDR:    mem_rdata <= pwm_period;
                    PWM_DUTY_ADDR:      mem_rdata <= pwm_duty;
                    UART_DATA_ADDR:     mem_rdata <= {31'd0, uart_busy};
                    default:            mem_rdata <= 32'd0;
                endcase
            end else begin
                mem_rdata <= 32'd0;
            end
        end
    end

endmodule
