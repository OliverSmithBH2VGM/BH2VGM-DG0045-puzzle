/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_BH2VGM_DG0045(
	input wire clk,  // main clock  // posedge effective // 8 posedge = 1 machine cycle
	input wire rst_n, // reset signal // low effective
	input wire ena, // nothing connect internally

	input wire[7:0] ui_in,  // connects to mainROM
	output wire[7:0] uo_out, // PC_HL[4:0] outs and nL[3:2] and ND
	input wire[7:0] uio_in, //KIN at uio_in[3:0], PC_MUX at uio_in[5]
	output wire[7:0] uio_out,// nL outs at uio_out[7:6]
	output wire[7:0] uio_oe// bit 0 means input ; bit 1 means output
);

wire[3:0] KIN; //input 
	assign KIN = uio_in[3:0];

wire PC_MUX; //input 	
	assign PC_MUX = uio_in[5];

wire[3:0] nL; //output 
wire ND; //output 
wire[4:0] PC_HL; //output 
	assign uo_out = {nL[2],nL[3],ND,PC_HL[4:0]};
	assign uio_out = {nL[0],nL[1],6'b000000};

wire[7:0] mainROM; //input 
	assign mainROM = ui_in;

assign uio_oe = 8'b1111_0000;  // nL0 | nL1 | PC_MUX | null | KIN | KIN | KIN | KIN 

parameter	
NOP = 8'h00,
//		ATG = 8'h01,
RC = 8'h02,
SC = 8'h03,
RMP = 8'h04,
KTA = 8'h08,
TC = 8'h09,
//		GTA = 8'h0A,
CADCSC = 8'h0B,
ADD = 8'h0C,
ADC = 8'h0E,
ADT = 8'h0F,
TAM = 8'h0D,
EXC = 8'h10,
EXCI = 8'h14,
LDA = 8'h18,
EXCD = 8'h1C,
LAM = 8'h20,
SKZ = 8'h30,
ADX = 8'h31,
DAA = 8'h36,
LB = 8'h40,
INCB = 8'h54,
RZ = 8'h55,
//CMPR = 8'h56,
SMP = 8'h58,
DECB = 8'h5c,
SZ = 8'h5d,
RET = 8'h5e,
RETSK = 8'h5f,
//		LBS = 8'h60,
SKMP = 8'h64,
//		ResetW=8'h68,
//		SetW=8'h69,
SHD0 = 8'h6a,
SHD1 = 8'h6b,
//LTSPU = 8'h6c,
ATL = 8'h6d,
RNP = 8'h6e,
SNP = 8'h6f,
SSP = 8'h70,
JMP = 8'h80,
CALL = 8'hC0;

//		Double_flag = 8'h57;

wire[7:0] NowState, LastState;
reg[7:0] nowCMD;

assign NowState = 
(nowCMD == 8'b00000010)?RC:
//		 (nowCMD == 8'b00000001)?ATG:
 (nowCMD == 8'b00000011)?SC:
 (nowCMD[7:2] == 6'b000001)?RMP:
 (nowCMD == 8'b00001000)?KTA:
 (nowCMD == 8'b00001001)?TC:
//		 (nowCMD == 8'b00001010)?GTA:
 (nowCMD == 8'b00001011)?CADCSC:
 (nowCMD == 8'b00001100)?ADD:
 (nowCMD == 8'b00001101)?TAM:
 (nowCMD == 8'b00001110)?ADC:
 (nowCMD == 8'b00001111)?ADT:

 (nowCMD[7:2] == 6'b000100)?EXC:
 (nowCMD[7:2] == 6'b000101)?EXCI:
 (nowCMD[7:2] == 6'b000110)?LDA:
 (nowCMD[7:2] == 6'b000111)?EXCD:

 (nowCMD[7:4] == 4'b0010)?LAM:
 (nowCMD == 8'b00110000)?SKZ:
 (nowCMD == 8'b00110110)?DAA:
 ((nowCMD[7:4] == 4'b0011)&&(nowCMD[3:0]!=4'b0000)&&(nowCMD[3:0]!=4'b0110))?ADX:

 (nowCMD[7:4] == 4'b0100) ?LB:
 (nowCMD[7:2] == 6'b010100) ?LB:

 (nowCMD == 8'b01010100)?INCB:
 (nowCMD == 8'b01010101)?RZ:
// (nowCMD == 8'h01010110)?CMPR;end

 (nowCMD[7:2] == 6'b010110)?SMP:
 (nowCMD == 8'b01011100)?DECB:

 (nowCMD == 8'b01011101)?SZ:
 (nowCMD == 8'b01011110)?RET:
 (nowCMD == 8'b01011111)?RETSK:

//		 (nowCMD[7:2] == 6'b011000)?LBS:
 (nowCMD[7:2] == 6'b011001)?SKMP:
//		 (nowCMD == 8'b01101000)?ResetW:
//		 (nowCMD == 8'b01101001)?SetW:
 (nowCMD == 8'b01101010)?SHD0:
 (nowCMD == 8'b01101011)?SHD1:
//		 (nowCMD == 8'b01101100)?LTSPU:
 (nowCMD == 8'b01101101)?ATL:
 (nowCMD == 8'b01101110)?RNP:
 (nowCMD == 8'b01101111)?SNP:

 (nowCMD[7:4] == 4'b0111) ?SSP:
 (nowCMD[7:6] == 2'b10) ?JMP:
 (nowCMD[7:6] == 2'b11) ?CALL:
NOP; 


assign LastState = 
(lastCMD[7:4] == 4'b0010)?LAM:
 (lastCMD[7:4] == 4'b0100) ?LB:
 (lastCMD[7:2] == 6'b010100) ?LB:
//		 (lastCMD[7:0] == 8'b01101100) ?LTSPU:
 (lastCMD[7:4] == 4'b0111) ?SSP:
//		 (lastCMD[7:0] == 8'h57) ?Double_flag:
NOP;


wire RESET;
	assign RESET = rst_n;
wire CLKF1,CLKF2;
reg[2:0] clock_devider;

	always@(posedge clk or negedge RESET)
begin
	if(RESET == 1'b0)begin
	clock_devider <= 3'b000;end
	
	else  begin
		clock_devider <= clock_devider + 3'b001;
	end
end

assign CLKF1 = (clock_devider[2:1] == 2'b01)? 1'b1:1'b0;
assign CLKF2 = (clock_devider[2:1] == 2'b11)? 1'b1:1'b0;

reg CLKEN;
wire F1,F2;
always@(negedge CLKF2 or negedge RESET)
begin
	if(RESET == 1'b0)begin
		CLKEN <= 1'b0;
	end
	else begin
		CLKEN <= 1'b1;
	end
end

assign F1 = CLKF1 & CLKEN;
assign F2 = CLKF2 & CLKEN;

//   	wire[7:0] mainROM;  //----
//		assign ROMout0 = nowCMD[0];
//		assign ROMout2 = nowCMD[2];

reg[7:0] lastCMD;

always @(negedge F1 or negedge RESET)
if(RESET==1'b0)begin
	nowCMD <= 8'b00000000;
	lastCMD <= 8'b00000000;
end
else begin
	//nowCMD <= ROMmask & mainROM ;
	nowCMD <= NRF?  mainROM : NOP ;
	lastCMD <= nowCMD;
end

//----------------
reg[5:0] PL;
reg[3:0] PU,SPU;
wire[1:0] PC_MODE ;
wire[9:0] PTR_STACK;
wire new_PL5;
wire STK_CLK,PC_CLK;

reg stk_flag,stk_flag_temp;
// program counter group
always @(negedge F2 or posedge F1 or negedge RESET)begin
	if(F1==1'b1 || RESET==1'b0)begin
		stk_flag_temp<=1'b1;
	end
	else begin
		stk_flag_temp <= 1'b0;
	end
end

always @(negedge F1 or negedge stk_flag_temp or negedge RESET)begin
	if(stk_flag_temp==1'b0 || RESET==1'b0)begin
		stk_flag <= 1'b0;
	end
	else begin
		stk_flag <= 1'b1;
	end
end

always @(posedge F2 or negedge RESET)begin
	if(RESET==1'b0)begin
		SPU<=4'b0000;
	end
	else begin
		if((NowState==RET || NowState==RETSK))begin
			SPU<=PTR_STACK[9:6];
		end
		else if((NowState==SSP) && (LastState!=SSP))begin
			SPU<=nowCMD[3:0];
		end
		else if((NowState==SSP) && (LastState==SSP))begin
			SPU<=SPU;
		end
		else begin
			SPU<=SPU;
		end
	end
end

assign PC_MODE[1] = (((NowState==RET) || (NowState==RETSK) || (NowState==CALL))) ? stk_flag: 1'b0;
assign PC_MODE[0] = (((NowState==RET) || (NowState==RETSK))) ? stk_flag: 1'b0;
assign STK_CLK = 
(F2==1'b1)&&((NowState==CALL)||(NowState==RET)||(NowState==RETSK)||(NowState==JMP))? 1'b1: 1'b0;
//assign STK_CLK = F2;

DG0040_SHIFTREGS DG0040_STACK(
.STK_CLK(STK_CLK),
.MODE1(PC_MODE[1]),
.MODE0(PC_MODE[0]),
.PC({PU,PL}),
.SP(PTR_STACK),
.PL1NXR0(new_PL5)
);

assign PC_CLK = F1 | STK_CLK;
always @(posedge PC_CLK or negedge RESET)begin
	if(RESET==1'b0)begin
		{PU,PL}<= 10'b0000_000000;
	end
	else begin
		if(stk_flag==1'b0)begin   // common count at F1
			{PU,PL}<={PU,new_PL5,PL[5:1]};
		end
		else begin	// for JMP CALL RET F2
			if((NowState==JMP)&&(LastState!=SSP))begin
				{PU,PL} <= {PU,nowCMD[5:0]};
			end
			else if((NowState==CALL)&&(LastState!=SSP))begin
				{PU,PL} <= {4'b1111,nowCMD[5:0]};
			end
			else if((nowCMD[7]==1'b1)&&(LastState==SSP))begin
				{PU,PL} <= {SPU,nowCMD[5:0]};
			end
			else if((NowState==RET)||(NowState==RETSK))begin
				{PU,PL} <= PTR_STACK;
			end
			else begin{PU,PL}<= {PU,PL}; end
		end
	end
end 

/*DG0040ROM DG0040_MY_ROM(
.Clk0(F1),
.ClkEn0(1'b1),
.AsyncReset0(1'b0),
.WeRenA(1'b0),
.AddressA({PS[1:0],PU,PL}),
.DataOutA(mainROM)
);*/

/*DG0040_ROMTWO DG0040_MY_ROM(
.ROM_ADDRESS({PS[1:0],PU,PL}),
.ROM_DATA(mainROM)

);*/

assign PC_HL = PC_MUX? {PU,PL[5]}:PL[4:0];

//----------------
reg[3:0] ACC;
wire[3:0] ALU_OUT;
reg CC,CC2;
wire[3:0] AtoRAM;
wire[3:0] RAMtoA,ALU_INA,ALU_INB;
wire RAM_WR_CMD;
wire CIN,COUT;

assign ALU_INB = ((NowState==ADX)||(NowState==DAA))? nowCMD[3:0]: RAMtoA;
assign ALU_INA = (NowState==CADCSC) ? ~ACC:ACC;

FULLADDER4 main_ALU
(
.Ain(ALU_INA),
.Bin(ALU_INB),
.Cin(CIN),
.Sout(ALU_OUT),
.Cout(COUT)
);

assign RAM_WR_CMD =(
((NowState == LAM) && (LastState==LAM)) ||
(NowState == SMP )||
(NowState == RMP)||
(NowState == EXC)||
(NowState == EXCI)||
(NowState == EXCD)
) 
? 1'b1: 1'b0;
// ACC groups

assign CIN =((NowState == ADC)||
(NowState==ADT)||
(NowState==CADCSC)
)? CC: 1'b0 ;


always @(posedge F2 or negedge RESET)
begin
	if(RESET == 1'b0) begin ACC<=4'b0000; end
	else  begin
		if((NowState==LDA)||(NowState==EXC)||(NowState==EXCI)||(NowState==EXCD)) 
			begin ACC<=RAMtoA; end
		else if((NowState==ADC)||(NowState==ADD)||(NowState==CADCSC)||(NowState==ADT)||(NowState==ADX)) 
			begin ACC<=ALU_OUT; end
		else if((NowState==DAA)&&((ACC>=4'b1010)||(CC==1'b1))) 
			begin ACC<=ALU_OUT; end
		else if((NowState==LAM)&&(LastState!=LAM)) 
			begin ACC<=nowCMD[3:0];end
		else if(NowState==KTA)
			begin ACC<=KIN;end
		else 
			begin ACC<=ACC; end
	end
end

always @(posedge F2 or negedge RESET)
begin
	if(RESET == 1'b0)begin CC<=1'b0; end
	else begin
		if(NowState==RC)begin
			CC<=1'b0;
		end
		else if(NowState==SC)begin
			CC<=1'b1;
		end
		else if(NowState==ADC || NowState==CADCSC || NowState==ADT )begin
			CC<=COUT;
		end
		else if ( (NowState==DAA) &&((ACC>=4'd10)||(CC==1'b1)) )
			CC<=1'b1;
		else begin CC<=CC; end
	end
end 

always @(posedge F2)
begin
	if(NowState==ADX)begin CC2<=COUT; end
	else begin CC2<=CC2; end
end


/*always @(*)begin   // SMP and RMP classes
	if(NowState==RMP)begin
		if(nowCMD[1:0]==2'b00)begin AtoRAM=(RAMtoA & 4'b1110);end
		else if(nowCMD[1:0]==2'b01)begin AtoRAM=(RAMtoA & 4'b1101);end
		else if(nowCMD[1:0]==2'b10)begin AtoRAM=(RAMtoA & 4'b1011);end
		else begin AtoRAM=(RAMtoA & 4'b0111); end
	end
	else if(NowState==SMP)begin
		if(nowCMD[1:0]==2'b00)begin AtoRAM=(RAMtoA | 4'b0001);end
		else if(nowCMD[1:0]==2'b01)begin AtoRAM=(RAMtoA | 4'b0010);end
		else if(nowCMD[1:0]==2'b10)begin AtoRAM=(RAMtoA | 4'b0100);end
		else begin AtoRAM=(RAMtoA | 4'b1000); end
	end
	else if(NowState==LAM)begin AtoRAM=nowCMD[3:0]; end
	else begin AtoRAM = ACC; end
end*/

wire[3:0] CD4555_decode;
assign CD4555_decode = (nowCMD[1:0]==2'b00)? 4'b0001:(nowCMD[1:0]==2'b01)? 4'b0010:(nowCMD[1:0]==2'b10)? 4'b0100:4'b1000;

assign AtoRAM=(NowState==RMP)? (RAMtoA & (~CD4555_decode) ) :(NowState==SMP)? (RAMtoA | CD4555_decode ) :(NowState==LAM)? nowCMD[3:0] : ACC ;

// RAM groups
reg[3:0] BL;
reg[1:0] BU;


always @(posedge F2 or negedge RESET)begin
	if(RESET==1'b0)begin
		{BU,BL} <= 6'b000000;
	end
	else begin
		if(((NowState==EXC) || (NowState==LDA)))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),BL};
		end
		else if((NowState==EXCI))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),(BL + 4'b0001)};
		end
		else if((NowState==EXCD))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),(BL + 4'b1111)};
		end
		else if((NowState==INCB))begin
			{BU,BL}<={BU,(BL + 4'b0001)};
		end
		else if((NowState==DECB))begin
			{BU,BL}<={BU,(BL + 4'b1111)};
		end
		else if(((NowState==LAM)&&(LastState==LAM)))begin
			{BU,BL}<={BU,(BL + 4'b0001)};
		end
		else if((NowState==LB)&&(LastState!=LB))begin
			if(nowCMD[4:2]==3'b000)begin
				{BU,BL}<={nowCMD[1:0],4'b0000};
			end
			else if(nowCMD[4:2]==3'b001)begin
					begin {BU,BL}<={nowCMD[1:0],4'b1101}; end
			end
			else if(nowCMD[4:2]==3'b010)begin
					begin {BU,BL}<={nowCMD[1:0],4'b1110}; end
			end
			else if(nowCMD[4:2]==3'b011)begin
				{BU,BL}<={nowCMD[1:0],4'b1111};
			end
			else begin
					begin {BU,BL}<={nowCMD[1:0],4'b1100};end
			end
		end
		else begin
			{BU,BL}<={BU,BL};
		end
	end
end

reg[3:0] LastBL;
always @(posedge F2 or negedge RESET)begin
	if(RESET==1'b0)begin
		LastBL <= 4'b0000;
	end
	else begin
		LastBL <= BL;
	end
end


wire RAM_WR;
assign RAM_WR = F2 & RAM_WR_CMD;

DG0045_RAM_256bit DG0040_MY_RAM
(
	
   .addr({BU,BL}),
   .din(AtoRAM),
	.clk(RAM_WR),
	.dout(RAMtoA)
	
);

wire NRF;
// SKIP group
assign NRF = (
((NowState==TC)&&(CC==1'b0)) ||
((NowState==CADCSC)&&(CC==1'b1)) ||
((NowState==TAM)&&(ACC==RAMtoA)) ||
((NowState==ADT)&&(CC==1'b0)) ||
((NowState==EXCI)&&(LastBL==4'b1011)) ||
((NowState==EXCD)&&(LastBL==4'b0000)) ||
((NowState==INCB)&&(LastBL==4'b1011)) ||
((NowState==DECB)&&(LastBL==4'b0000)) ||
((NowState==SKZ)&&(Zreg==1'b1)) ||
((NowState==ADX)&&(CC2==1'b0)) ||
((NowState==SKMP)&&(nowCMD[1:0]==2'b00)&&(RAMtoA[0]==1'b1)) ||
((NowState==SKMP)&&(nowCMD[1:0]==2'b01)&&(RAMtoA[1]==1'b1)) ||
((NowState==SKMP)&&(nowCMD[1:0]==2'b10)&&(RAMtoA[2]==1'b1)) ||
((NowState==SKMP)&&(nowCMD[1:0]==2'b11)&&(RAMtoA[3]==1'b1)) ||
((NowState==RETSK))
) ? 1'b0:1'b1;

// Zreg group
reg Zreg;
always @(posedge F2 or negedge RESET)
begin
	if(RESET==1'b0)begin Zreg <= 1'b0;end
	else begin
		if((NowState==SZ))begin Zreg <= 1'b1;end
		else if((NowState==RZ))begin Zreg <= 1'b0;end
		else  begin Zreg<= Zreg;end
	end 
end

// other drives
assign ND = 
((NowState == SHD0)||(NowState == SHD1)||(NowState == RNP)||(NowState == SNP)) ? (~F2): 1'b1;

// Lreg group
reg[3:0] Lreg;

//assign nL = PU;
always @(posedge F2 or negedge RESET)
begin
	if(RESET==1'b0)begin
		Lreg <= 4'b0000;
	end
	else begin
		if(((NowState==ATL)||(NowState==SNP)))begin
			Lreg <= ACC;
		end
		else if(NowState==RNP)begin
			Lreg <= 4'b0000;
		end
		else begin  Lreg<=Lreg; end
	end
end

assign nL = ~Lreg;

//****G 

endmodule


module DG0045_RAM_256bit(
           input   wire clk  ,
           input   wire[5:0] addr ,
           input   wire[3:0]din  ,
           output wire[3:0]dout
          );
 
reg [3:0] mem [0:63];
 
always @(posedge clk)
begin
        mem [addr] <= din;
end

assign   dout = mem [addr] ;

endmodule


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


module DG0040_SHIFTREGS(
input wire STK_CLK,
input wire MODE1,
input wire MODE0,
input wire[9:0] PC,
output wire[9:0] SP,
output wire PL1NXR0
);
	
	reg[9:0] SPA,SPB,SPC,SPD,SPE;
	

	assign PL1NXR0 = (PC[0]==PC[1]) ? 1'b1:1'b0;
	assign SP = SPA;
	
	always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPE <= SPD;
			SPD <= SPC;
			SPC <= SPB;
			SPB <= SPA;
			SPA <= PC;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPE <= 10'b0000_000000;
			SPD <= SPE;
			SPC <= SPD;
			SPB <= SPC;
			SPA <= SPB;
		end
		else begin
			SPE <= SPE;
			SPD <= SPD;
			SPC <= SPC;
			SPB <= SPB;
			SPA <= SPA;
		end
	end
endmodule
