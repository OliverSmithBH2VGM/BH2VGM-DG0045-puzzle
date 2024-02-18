<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

DG0045 CPU has a program space of 1008byte (16*63 with 8bit/perbyte) and a RAM space of 64*4bits, in this cut, all operations are in single byte and cost up 8 clock posedge(internal is divided into CLKF1 and CLKF2). The CPU uses K port as input signal, and nL as output signal. At the same time, signal ROM[2], ROM[0] and ND are used to extend outputs use CD4094 and some other CMOS chips...

## How to test

signal "PC_HL" is used as PC output and muntiplexed by signal "PC_MUX" to switch output of high 5bits or lows;
signal "mainROM" is used as construction input;
signal "KIN" is input only 
signal "nL" and "ND" is output only
at last, signal CLK_main, RESET are clock and reset signals.

## External hardware

An aux. chip DG0041 is ready in FPGA, connecting them together with 12 digit-LEDs and a 4*5 key array may start up a simple float-point calculator
