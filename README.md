# Floating-Point Multiplier in SystemVerilog

## Overview

This repository contains the implementation of a **single-precision floating-point multiplier** developed as part of an ECE Hardware II course assignment, along with additional verification work completed afterward for personal practice.

The original objective of the project was to design and validate a floating-point multiplier in **SystemVerilog**, handling normal arithmetic behavior, rounding, and exceptional cases. After completing the coursework requirements, I extended the repository by beginning a **UVM-based verification environment** as a self-driven exercise to strengthen skills relevant to **Digital Verification Engineer** roles.

This project is therefore primarily a **digital design project with verification elements**, and also reflects an intentional effort to grow from directed verification toward a more structured, reusable verification methodology.

---

## Project Goals

The project focuses on:

- Designing a **32-bit floating-point multiplier**
- Implementing arithmetic stages such as:
  - sign calculation
  - exponent processing
  - mantissa multiplication
  - normalization
  - rounding
  - exception handling
- Producing result **status flags** for special conditions
- Comparing DUT behavior against a provided reference function
- Exploring the structure of a **UVM verification environment** as a follow-up learning effort

---

## Design Summary

The DUT is organized as a modular floating-point multiplication pipeline in combinational logic, wrapped by a top-level module used in simulation.

### High-level dataflow

The multiplier follows the standard decomposition of floating-point multiplication:

1. **Sign computation**  
   The result sign is generated from the XOR of the operand signs.

2. **Exponent calculation**  
   The exponents are added and adjusted by the IEEE-754 single-precision bias.

3. **Mantissa multiplication**  
   The significands are multiplied to form an intermediate product.

4. **Normalization**  
   The mantissa product is normalized and guard/sticky information is generated.

5. **Rounding**  
   The normalized result is rounded according to the selected rounding mode.

6. **Exception and special-case handling**  
   The final result and status flags are adjusted for cases such as zero, infinity, NaN-like behavior, overflow, underflow, tiny, huge, and inexact outcomes.

---

## Supported Rounding Modes

The design includes support for multiple rounding modes through an enumerated package:

- `IEEE_near`
- `IEEE_zero`
- `IEEE_pinf`
- `IEEE_ninf`
- `near_up`
- `away_zero`

This allows the multiplier to be exercised across different rounding policies rather than only the default IEEE nearest mode.

---

## RTL Structure

### `fp_mult/fp_mult.sv`
Core floating-point multiplier module.  
This module performs the main arithmetic flow and connects the normalization, rounding, and exception submodules.

### `fp_mult/normalize_mult.sv`
Normalizes the mantissa product and generates:
- normalized exponent
- normalized mantissa
- guard bit
- sticky bit

### `fp_mult/round_mult.sv`
Implements rounding behavior for the supported rounding modes and updates the exponent when rounding causes mantissa carry-out.

### `fp_mult/exception_mult.sv`
Handles result classification and special-case output generation, including status flag generation for:
- zero
- infinity
- NaN-related cases
- tiny
- huge
- inexact

### `fp_mult/fp_mult_top.sv`
Top-level simulation wrapper that registers inputs/outputs and also exposes the provided reference function result for comparison during simulation.

### `fp_mult/round_enum_pkg.sv`
Defines the rounding mode enumeration used across the design and verification code.

---

## Verification Approach

The repository contains two verification directions:

### 1. Coursework-oriented checking
The original assignment included a provided reference function, used here through:

- `Verification/multiplication.sv`
- `z_function_out` in the top-level wrapper

This supports direct comparison between the DUT result and the expected behavior defined by the coursework reference model.

### 2. Additional self-driven verification work
After the course assignment, I started building a **UVM-based environment** as a personal learning exercise. This part of the repository is intentionally included because it reflects my effort to move beyond directed testing and gain hands-on experience with industry-oriented verification structure.

The UVM work in this repository should be viewed as an **incomplete, self-driven work in progress**, not as a fully closed verification solution. Its purpose was to practice:
- transaction-based stimulus
- sequencer/driver structure
- environment/test organization
- interface-based DUT connectivity

This was valuable as an early step in applying verification methodology concepts to a design I already understood well at the RTL level.

---

## UVM Verification Files

The `Verification/` directory includes the initial structure of a UVM environment:

- `fp_mult_transaction.sv` — transaction definition
- `fp_mult_sequence.sv` — randomized stimulus generation
- `fp_mult_driver.sv` — drives transactions onto the DUT interface
- `fp_mult_env.sv` — environment container
- `fp_mult_test.sv` — test entry point
- `fp_mult_if.sv` — virtual interface
- `tb_fp_mult_TOP.sv` — top-level UVM testbench

In addition, the repository contains assertion-oriented and directed verification files such as:

- `test_status_bits.sv`
- `test_status_z_combinations.sv`
- `fp_mult_tb.sv`

These reflect a mix of directed validation, property-based checks, and early UVM experimentation.

---

## Status Flags

The multiplier produces an 8-bit status output to indicate special result conditions. Internally, the implementation tracks flags such as:

- zero
- infinity
- NaN-related condition
- tiny
- huge
- inexact

These flags are part of the design intent and are also exercised in the verification-oriented files included in the repository.

---

## File Lists

The project includes filelists for RTL and testbench compilation:

- `filelists/fp_mult_rtl.f`
- `filelists/fp_mult_tb.f`

These were used to organize compilation in **Questa**.

---

## Development Environment

- **Language:** SystemVerilog
- **Simulator:** Questa
- **Verification style:** Directed checks, assertion-based checks, and early UVM practice

---

## What This Project Demonstrates

From an engineering perspective, this repository demonstrates:

- Ability to decompose a floating-point arithmetic problem into clean RTL sub-blocks
- Understanding of datapath operations such as exponent handling, normalization, and rounding
- Awareness of special-case behavior and status flag generation
- Experience working with **SystemVerilog** for both design and verification
- Early hands-on exposure to **UVM structure and methodology**
- Initiative to extend a university assignment into a more verification-oriented personal project

---

## Notes

This repository originated as an academic design assignment, so the primary emphasis is on implementing the multiplier correctly and organizing the arithmetic/control logic clearly. The verification content was later expanded independently as part of my own preparation for verification-focused roles.

The UVM portion is intentionally left in the repository because it shows the beginning of that transition: from verifying a design at the assignment level to thinking in terms of reusable verification components and methodology-driven testbench structure.

---

## Repository Structure

```text
apostolgs-multiplier_hw_ii/
├── filelists/
│   ├── fp_mult_rtl.f
│   └── fp_mult_tb.f
├── fp_mult/
│   ├── exception_mult.sv
│   ├── fp_mult.sv
│   ├── fp_mult_top.sv
│   ├── normalize_mult.sv
│   ├── round_enum_pkg.sv
│   └── round_mult.sv
└── Verification/
    ├── fp_mult_driver.sv
    ├── fp_mult_env.sv
    ├── fp_mult_if.sv
    ├── fp_mult_scoreboard.sv
    ├── fp_mult_sequence.sv
    ├── fp_mult_tb.sv
    ├── fp_mult_test.sv
    ├── fp_mult_transaction.sv
    ├── multiplication.sv
    ├── tb_fp_mult_TOP.sv
    ├── test_status_bits.sv
    └── test_status_z_combinations.sv
