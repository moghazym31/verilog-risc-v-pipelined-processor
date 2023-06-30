# RISC-V Pipelined Processor with M Extension

This repository contains the implementation of a pipelined RISC-V processor. The processor is capable of executing all 40 instructions of the RV32I Base Instruction Set, along with all instructions provided by the M extension for multiplication and division. The project is structured as follows:

## Directory Structure

- `descriptions/`: This directory contains the Verilog descriptions of the various modules used in the processor implementation. Each module represents a specific component of the processor, such as ALU, control unit, register file, data and instruction memories, etc.

- `tb/`: This directory contains the testbench files used to simulate and verify the functionality of the pipelined processor. The `PipelinedTB.v` file is the main testbench file.

## Supported Instructions

The implemented pipelined processor supports the following instructions:

### RV32I Base Instruction Set:

- Arithmetic Instructions: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
- Immediate Instructions: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
- Load and Store Instructions: LUI, AUIPC, LB, LH, LW, LBU, LHU, SB, SH, SW
- Control Transfer Instructions: JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU
- Miscellaneous Instructions: LUI, AUIPC
- System Instructions: ECALL, EBREAK

### M Extension Instructions:

- Multiplication and Division: MUL, MULH, MULHU, MULHSU, DIV, DIVU, REM, REMU

## Usage

To run the test cases, uncomment the desired batch in the `DataAndInstructionMemory.v` file or create your own.

## Schematic

The full data path schematic can be seen below:
![Full Data Path](https://s11.gifyu.com/images/SQtHG.png)

## Results

Batch 1 tests following instructions in one program:
`ADD`, `LW`, `ADD`, `SUB`, `ADDI`, `AND`, `ANDI`, `OR`, `XOR`, `XORI`, `ORI`, `SLLI`, `SLL`, `SRLI`, `SRL`, `SLT`, `SLT`, `SLTU`, `SLTI`, and `SLTIU`.

Batch 1 Test Cases Final Register File:
![Full Data Path](https://s11.gifyu.com/images/SQtKz.png)

Batch 2 tests following instructions in one program:
`LB` , `SRA`, `SRAI`, `LBU`, `LHU`, `LH`, `SB`, `LBU`, `SH`, `SW`, `LUI`, and `AUIPC`.

Batch 2 Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtKb.png)

Batch 3 tests following instructions in one program:
`BLTU`, `BNE`, `BEQ`, `BLT`, `BGE`, `BGEU`, `JAL`, and `JALR`.

Batch 3 (BEQ branch taken) Test Cases Final Register File:
![Full Data Path](https://s11.gifyu.com/images/SQtKL.png)

Batch 3 (BNE branch not taken) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtKF.png)

Batch 3 (BGE branch taken) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtKH.png)

Batch 3 (BGEU branch not taken) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtKN.png)

Batch 3 (BLT branch not taken) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtK4.png)

Batch 3 (BLTU branch taken) Test Cases Final Register File:
![Full Data Path](https://s11.gifyu.com/images/SQtK6.png)

Batch 3 (JAL) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtNx.png)

Batch 3 (JALR) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtNK.png)

Batch 4 tests following instructions in one program:
`MUL`, `MULH`, `MULHSU`, `MULHU`, `DIV`, `DIVU`, `REM`, and `REMU`.

Batch 4 (BLTU branch taken) Test Cases Final Register File:
![Full Data Path](https://s12.gifyu.com/images/SQtK8.png)
