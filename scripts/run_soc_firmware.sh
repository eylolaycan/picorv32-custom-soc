#!/bin/bash
set -e

./scripts/build_firmware.sh

iverilog -o sim/soc_fw_tb.out \
rtl/picorv32.v \
rtl/simple_ram.v \
rtl/timer.v \
rtl/pwm.v \
rtl/uart_tx.v \
rtl/soc.v \
tb/tb_soc.v

vvp sim/soc_fw_tb.out
