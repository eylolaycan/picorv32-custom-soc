// rtl/gpio.v

module gpio (
    input  wire [7:0] gpio_in,
    input  wire [7:0] gpio_out_value,

    output wire [7:0] gpio_out,
    output wire [7:0] gpio_read
);

    assign gpio_out  = gpio_out_value;
    assign gpio_read = gpio_in;

endmodule
