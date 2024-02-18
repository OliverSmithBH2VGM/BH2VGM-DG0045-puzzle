/*
 * Copyright (c) 2024 OliverSmithBH2VGM
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_BH2VGM_DG0045(
	input wire clk,  // main clock  // posedge effective // 8 posedge = 1 machine cycle
	input wire rst_n, // reset signal // low effective
	input wire ena, // if ena = 1, CPU works, else, clk has no effect

	input wire[7:0] ui_in,  // connects to mainROM
	output wire[7:0] uo_out, // PC_HL[4:0] outs and nL[3:2] and ND
	input wire[7:0] uio_in, //KIN at uio_in[3:0], PC_MUX at uio_in[5]
	output wire[7:0] uio_out,// nL outs at uio_out[7:6]
	output wire[7:0] uio_oe// bit 0 means input ; bit 1 means output
);

	reg[7:0] outregs;

	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n==1'b0)begin outregs <= 8'b00000000  ; end
		else begin outregs <= ena? uio_in:ui_in; end
	end
	assign uo_out = outregs;
	assign uio_oe = 8'b00001111;
	assign uio_out = 8'b00001111;
endmodule
