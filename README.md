
# Digital Clock on Basys 3 FPGA

## Overview

This project implements a digital clock in Verilog HDL on the Basys 3 FPGA development board. The design uses the onboard 100 MHz clock, which is divided down to 1 Hz to generate real-time second increments. Time is maintained in hours, minutes, and seconds, while the four-digit seven-segment display shows the current time in MM format.

## Features

* Verilog HDL implementation
* Basys 3 FPGA compatible
* 100 MHz onboard clock divided to 1 Hz
* Seconds counter (00–59)
* Minutes counter (00–59)
* Hours counter (00–23)
* Four-digit seven-segment display multiplexing
* MM display format
* Asynchronous reset support

## Project Structure

sourcefile.v      - Complete Verilog source code
basys3.xdc        - Basys 3 constraints file
simulation.v      - Simulation testbench 

## Design Modules

### Clock Divider

Divides the 100 MHz onboard clock to generate a 1 Hz clock signal used for timekeeping.

### Seconds Counter

Counts from 0 to 59 and generates a carry signal when rolling over.

### Minutes Counter

Increments when the seconds counter rolls over from 59 to 0.

### Hours Counter

Increments when the minutes counter rolls over from 59 to 0 and operates in 24-hour format.

### Seven-Segment Display Driver

Multiplexes the four display digits and converts numerical values into seven-segment patterns.

## Hardware Requirements

* Basys 3 FPGA Development Board
* Vivado Design Suite

## Simulation

The design can be simulated using a testbench. For faster simulation, the clock divider count may be temporarily reduced to observe counter operation without waiting for real-time clock periods.

## FPGA Implementation

1. Create a Vivado project.
2. Add the Verilog source file(s).
3. Add the Basys 3 constraints file (`.xdc`).
4. Run Synthesis.
5. Run Implementation.
6. Generate Bitstream.
7. Program the FPGA.

## Display Format

MM:SS

## Tools Used

* VS code
* Verilog HDL
* Xilinx Vivado
* Basys 3 FPGA Board

## Author

Adapa Prajusha Sree

