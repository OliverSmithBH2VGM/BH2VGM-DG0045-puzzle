module FULLADDER4
(
	input wire[3:0] Ain,
	input wire[3:0] Bin,
	input wire Cin,
	output wire[3:0] Sout,
	output wire Cout
);

wire[4:0] A_IN_t,B_IN_t,C_IN_t;
wire[4:0] A_OUT;
assign A_IN_t = {1'b0,Ain};
assign B_IN_t = {1'b0,Bin};
assign C_IN_t = {4'b0000,Cin};
assign A_OUT = A_IN_t + B_IN_t + C_IN_t;
assign Sout = A_OUT[3:0];
assign Cout = A_OUT[4];

endmodule
