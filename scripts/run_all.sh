#!/bin/bash

set -e

echo "Running timer test..."
iverilog -o sim/timer_tb.out rtl/timer.v tb/tb_timer.v
vvp sim/timer_tb.out

echo "Running PWM test..."
iverilog -o sim/pwm_tb.out rtl/pwm.v tb/tb_pwm.v
vvp sim/pwm_tb.out

echo "Running UART TX test..."
iverilog -o sim/uart_tx_tb.out rtl/uart_tx.v tb/tb_uart_tx.v
vvp sim/uart_tx_tb.out

echo "Running peripheral bus test..."
iverilog -o sim/peripheral_bus_tb.out \
rtl/picorv32.v \
rtl/simple_ram.v \
rtl/timer.v \
rtl/pwm.v \
rtl/uart_tx.v \
rtl/soc.v \
tb/tb_peripheral_bus.v

vvp sim/peripheral_bus_tb.out

echo "All tests passed."
