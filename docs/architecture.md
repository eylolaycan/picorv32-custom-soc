# System Architecture

## Overview

The SoC is built around the PicoRV32 RISC-V processor and follows a hierarchical architecture. Instead of implementing the entire design as a single flat netlist, the system is composed of three independent hard macros integrated at the top level.

The major blocks are:

- PicoRV32 CPU
- Simple RAM
- Peripheral Subsystem

The CPU communicates with the peripherals through a memory-mapped interface. The RAM provides instruction and data storage, while the peripheral subsystem contains GPIO, Timer, UART Transmitter, and PWM modules.

## Memory Map

The peripherals are accessed through dedicated memory addresses, allowing software running on the CPU to configure hardware modules using standard read and write transactions.

## Hierarchical Integration

Each major subsystem is implemented independently before being integrated into the top-level SoC. This hierarchical methodology reduces implementation complexity and resembles modern industrial ASIC design practices.
