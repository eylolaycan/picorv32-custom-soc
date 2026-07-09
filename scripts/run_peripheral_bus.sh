#!/bin/bash

iverilog -o sim/peripheral_bus_tb.out \
rtl/picorv32.v \
rtl/simple_ram.v \
rtl/timer.v \
rtl/pwm.v \
rtl/uart_tx.v \
rtl/soc.v \
tb/tb_peripheral_bus.v

vvp sim/peripheral_bus_tb.out
