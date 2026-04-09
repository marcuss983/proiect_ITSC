# 16-bit General Purpose Processor with ASIP Crypto Core

## Overview

This project implements a **16-bit General Purpose Processor (GPP)** together with a simple **ASIP (Application-Specific Instruction-set Processor) crypto core**, designed and simulated in **Verilog**.

The processor supports:
- arithmetic and logic instructions
- shift and rotate instructions
- compare and test instructions
- dedicated registers and flags
- separate instruction and data memories
- a custom crypto instruction executed through an ASIP module

The design was tested in **ModelSim** using a custom testbench.

---

## Project Goals

The main goal of this project is to design a small 16-bit processor architecture and extend it with a specialized hardware module for cryptographic-style processing.

The processor includes:
- a standard datapath
- a control unit
- an ALU
- register bank
- memory modules
- a custom crypto core activated through a dedicated instruction

---

## Architecture

The processor is built around the following main components:

### Registers
The register bank includes:
- `A` – accumulator register
- `X` – general-purpose register
- `Y` – general-purpose register
- `PC` – program counter
- `SP` – stack pointer
- `FLAGS` – status flags register

### Flags
The ALU generates 4 flags:
- `Z` – Zero
- `N` – Negative
- `C` – Carry
- `V` – Overflow

### Memories
The design uses **two separate memories**:
- **Instruction Memory (`i_mem`)** – stores program instructions
- **Data Memory (`d_mem`)** – stores data and can be used for load/store operations

This separation simplifies instruction fetch and data access.

### ALU
The ALU executes arithmetic, logic, shift, and rotate operations.

### Control Unit
The control unit decodes the instruction and generates all control signals:
- register write enables
- ALU operation select
- memory control signals
- PC update signals
- ASIP enable

### ASIP Crypto Core
A custom module named `crypto_core` is included as a hardware accelerator.
It is activated by a dedicated instruction and produces a specialized output that is written back into register `A`.

---

## Instruction Format

Each instruction is 16 bits wide.

### General format
- `instr[15:10]` – opcode
- `instr[9]` – register select bit
- `instr[8:0]` – immediate value

### Register select bit
- `0` → operate on `X`
- `1` → operate on `Y`

---

## Supported Instructions

### Arithmetic / Logic
- `ADD`
- `SUB`
- `MOV`
- `MUL`
- `DIV`
- `MOD`
- `AND`
- `OR`
- `XOR`
- `NOT`
- `INC`
- `DEC`

### Shift / Rotate
- `LSL` – logical shift left
- `LSR` – logical shift right
- `RSL` – rotate left
- `RSR` – rotate right

### Comparison / Test
- `CMP`
- `TST`

### Custom ASIP Instruction
- `ASIP_ENCRYPT`

---

## Example Program Flow

A sample test program used in simulation includes instructions such as:

- `MOV X, 20`
- `SUB X, 6`
- `ADD X, 2`
- `MUL X, 2`
- `DIV X, 4`
- `MOD X, 3`
- `AND X, 15`
- `OR X, 16`
- `XOR X, 7`
- `NOT X`
- `INC X`
- `DEC X`
- `LSL X, 1`
- `LSR X, 1`
- `RSL X, 1`
- `RSR X, 1`
- `CMP X, 15`
- `TST X`
- `ASIP_ENCRYPT`

These instructions were observed in ModelSim waveform simulations.

---

## Files

### Main modules
- `top_processor.v` – top-level CPU module
- `control_unit.v` – instruction decoder and control logic
- `alu.v` – arithmetic logic unit
- `registers.v` – register bank
- `memory.v` – generic memory module
- `sign_extend.v` – immediate extension
- `crypto_core.v` – ASIP crypto core

### Testbench
- `test_program.v` – processor simulation program
- `tb_alu.v` – ALU testbench
- `tb_registers.v` – registers testbench

---

## Simulation

The project was simulated in **ModelSim**.

### Basic simulation flow
1. Compile all Verilog files
2. Load `test_program` as top module
3. Run simulation
4. Inspect signals in Wave

### Important signals in Wave
- `PC`
- `instr`
- `A`, `X`, `Y`
- `alu_res`
- `asip_res`
- `w_data`
- `flags_stored`
- `asip_en`

---

## How the ASIP Works

The ASIP is enabled through a dedicated control signal:
- `asip_en = 1`

When active:
- the result written back into the processor comes from `crypto_core`
- instead of using the normal ALU result

This allows the processor to execute a specialized operation that is not part of the standard ALU.

---

## Design Notes

- The processor is implemented in Verilog
- The architecture is 16-bit
- Separate instruction and data memories were used to simplify fetch and memory access
- The project was validated through waveform analysis in ModelSim

---

## Possible Future Improvements

- support for branch and jump instructions
- full stack-based call/return mechanism
- more advanced ASIP crypto algorithm
- larger instruction set
- better hazard handling and multi-cycle execution
- memory-mapped I/O support

---

## Authors

Project developed by the team for the **ITSC** course.

---

## License

This project is for educational use.
