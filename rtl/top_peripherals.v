// rtl/top_peripherals.v

module top_peripherals (
    input  wire        clk,
    input  wire        resetn,

    input  wire [7:0]  gpio_in,
    input  wire [7:0]  gpio_out_value,

    input  wire        timer_enable,
    input  wire        timer_clear,
    input  wire [31:0] timer_compare,

    input  wire        pwm_enable,
    input  wire [31:0] pwm_period,
    input  wire [31:0] pwm_duty,

    input  wire        uart_start,
    input  wire [7:0]  uart_data,

    output wire [7:0]  gpio_out,
    output wire [7:0]  gpio_read,

    output wire [31:0] timer_counter,
    output wire        timer_irq,

    output wire        pwm_out,

    output wire        uart_tx_line,
    output wire        uart_busy
);

    gpio u_gpio (
        .gpio_in(gpio_in),
        .gpio_out_value(gpio_out_value),
        .gpio_out(gpio_out),
        .gpio_read(gpio_read)
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
        .tx(uart_tx_line),
        .busy(uart_busy)
    );

endmodule
