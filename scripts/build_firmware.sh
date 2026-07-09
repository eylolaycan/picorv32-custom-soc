#!/bin/bash
set -e

riscv64-unknown-elf-gcc \
-march=rv32im -mabi=ilp32 \
-nostdlib -nostartfiles \
-T firmware/linker.ld \
firmware/start.S firmware/main.c \
-o firmware/main.elf

riscv64-unknown-elf-objcopy -O binary firmware/main.elf firmware/main.bin

python3 - <<'PY'
from pathlib import Path

data = Path("firmware/main.bin").read_bytes()

while len(data) % 4 != 0:
    data += b"\x00"

with open("firmware/main.hex", "w") as f:
    for i in range(0, len(data), 4):
        word = data[i:i+4]
        value = word[0] | (word[1] << 8) | (word[2] << 16) | (word[3] << 24)
        f.write(f"{value:08x}\n")

print(f"Wrote firmware/main.hex with {len(data)//4} words")
PY
