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
	wire[2:0] uio_void;
	assign uio_void = {uio_in[7:6],uio_in[4]};
	
wire[3:0] KIN; //input 
	assign KIN = uio_in[3:0];

wire PC_MUX; //input 	
	assign PC_MUX = uio_in[5];

wire[3:0] nL; //output 
wire ND; //output 
wire[4:0] PC_HL; //output 
	assign uo_out = {nL[2],nL[3],ND,PC_HL[4:0]};
	assign uio_out = {nL[0],nL[1],3'b000,uio_void};

wire[7:0] mainROM; //input 
	assign mainROM = ui_in;

assign uio_oe = 8'b1111_0000;  // nL0 | nL1 | PC_MUX | null | KIN | KIN | KIN | KIN 
	

//wire RC;wire SC;
wire RSC;
wire RMP;wire KTA;wire TC;

wire CADCSC;wire ADD;wire ADC;wire ADT;wire TAM;
wire EXC;
wire EXCI;
wire LDA;
wire EXCD;
wire LAM;
wire SKZ;
wire ADX;wire DAA;
wire LB;
wire INCB;
//wire RZ;
wire RSZ;
	
wire SMP;
wire DECB;
//wire SZ;
wire RET;

wire SKMP;
wire SHD;

wire ATL;wire RNP;wire SNP;
wire SSP;wire JMP;wire CALL;

wire LastLAM,LastLB,LastSSP;

reg[7:0] nowCMD;

//	assign RC=(nowCMD == 8'b00000010)?1'b1:1'b0;
// 	assign SC=(nowCMD == 8'b00000011)?1'b1:1'b0;
	assign RSC = (nowCMD[7:1] == 7'b0000001)?1'b1:1'b0;
	
 	assign RMP = (nowCMD[7:2] == 6'b000001)?1'b1:1'b0;
  	assign KTA=(nowCMD == 8'b00001000)?1'b1:1'b0;
  	assign TC=(nowCMD == 8'b00001001)?1'b1:1'b0;
//		 (nowCMD == 8'b00001010)?GTA:
  	assign CADCSC=(nowCMD == 8'b00001011)?1'b1:1'b0;
  	assign ADD=(nowCMD == 8'b00001100)?1'b1:1'b0;
  	assign TAM=(nowCMD == 8'b00001101)?1'b1:1'b0;
  	assign ADC=(nowCMD == 8'b00001110)?1'b1:1'b0;
  	assign ADT=(nowCMD == 8'b00001111)?1'b1:1'b0;

  	assign EXC=(nowCMD[7:3] == 5'b00010)?1'b1:1'b0;
  	assign EXCI=(nowCMD[7:2] == 6'b000101)?1'b1:1'b0;
 	assign LDA =(nowCMD[7:3] == 5'b00011)?1'b1:1'b0;
 	assign EXCD= (nowCMD[7:2] == 6'b000111)?1'b1:1'b0;

  	assign LAM=(nowCMD[7:4] == 4'b0010)?1'b1:1'b0;
 	assign SKZ=(nowCMD == 8'b00110000)?1'b1:1'b0;
 	assign DAA= (nowCMD == 8'b00110110)?1'b1:1'b0;
 	assign ADX= ((nowCMD[7:4] == 4'b0011)&&(nowCMD[3:0]!=4'b0000)&&(nowCMD[3:0]!=4'b0110))?1'b1:1'b0;

 	assign  LB = ((nowCMD[7:4] == 4'b0100)||(nowCMD[7:2] == 6'b010100) ) ?1'b1:1'b0;
// 	assign  LB = (nowCMD[7:4] == 4'b0100) ?1'b1:1'b0;

 	assign INCB= (nowCMD == 8'b01010100) ?1'b1:1'b0;
//  	assign RZ=(nowCMD == 8'b01010101) ?1'b1:1'b0;
// (nowCMD == 8'h01010110)?CMPR;end
	assign RSZ = (nowCMD[7:4] == 4'b0101||nowCMD[2:0] == 3'b101 ) ? 1'b1:1'b0;

  	assign SMP=(nowCMD[7:2] == 6'b010110) ?1'b1:1'b0;
  	assign DECB=(nowCMD == 8'b01011100) ?1'b1:1'b0;

//  	assign SZ=(nowCMD == 8'b01011101) ?1'b1:1'b0;
 	assign RET =(nowCMD[7:1] == 7'b0101111) ?1'b1:1'b0;

//		 (nowCMD[7:2] == 6'b011000)?LBS:
  	assign SKMP=(nowCMD[7:2] == 6'b011001)?1'b1:1'b0;
//		 (nowCMD == 8'b01101000)?ResetW:
//		 (nowCMD == 8'b01101001)?SetW:
 	assign  SHD= (nowCMD[7:1] == 7'b0110101)?1'b1:1'b0;
//		 (nowCMD == 8'b01101100)?LTSPU:
  	assign ATL=(nowCMD == 8'b01101101)?1'b1:1'b0;
 	assign RNP= (nowCMD == 8'b01101110)?1'b1:1'b0;
  	assign SNP=(nowCMD == 8'b01101111)?1'b1:1'b0;

 	assign SSP= (nowCMD[7:4] == 4'b0111) ?1'b1:1'b0;
 	assign JMP= (nowCMD[7:6] == 2'b10) ?1'b1:1'b0;
 	assign CALL= (nowCMD[7:6] == 2'b11) ?1'b1:1'b0;

assign 	LastLAM=(lastCMD[5:2] == 4'b0010)?1'b1:1'b0;
assign 	LastLB=((lastCMD[5:2] == 4'b0100)||(lastCMD[5:0] == 6'b010100))?1'b1:1'b0;
//assign 	LastLB=(lastCMD[3:0] == 4'b0100)?1'b1:1'b0;
assign 	LastSSP=(lastCMD[5:2] == 4'b0111)?1'b1:1'b0;


wire RESET;
	assign RESET = rst_n;
wire clk_in;
	assign clk_in = clk;
wire CLKF1,CLKF2;
reg[2:0] clock_divider;

always@(posedge clk_in or negedge RESET)begin
	if(RESET == 1'b0)begin clock_divider <=3'b000; end
	else if(ena==1'b1) begin clock_divider <= clock_divider + 3'b001; end
	else begin clock_divider <= clock_divider; end
end

assign CLKF1 = (clock_divider[2:1] == 2'b01)? 1'b1:1'b0;
assign CLKF2 = (clock_divider[2:1] == 2'b11)? 1'b1:1'b0;

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

	reg[5:0] lastCMD;

always @(negedge F1 or negedge RESET)
if(RESET==1'b0)begin
	nowCMD <= 8'b00000000;
	lastCMD <= 6'b000000;
end
else begin
	//nowCMD <= ROMmask & mainROM ;
	nowCMD <= NRF?  mainROM : 8'b00000000 ;
	lastCMD <= nowCMD[7:2];
end

//----------------
reg[5:0] PL;
reg[3:0] PU,SPU;
wire[1:0] PC_MODE ;
wire[9:0] PTR_STACK;
wire new_PL5;
wire STK_CLK,PC_CLK;

wire stk_flag;
// program counter group
assign stk_flag = clock_divider[2];

always @(posedge F2 or negedge RESET)begin
	if(RESET==1'b0)begin
		SPU<=4'b0000;
	end
	else begin
		if(RET==1'b1)begin
			SPU<=PTR_STACK[9:6];
		end
		else if((SSP==1'b1) && (LastSSP==1'b0))begin
			SPU<=nowCMD[3:0];
		end
		else if((SSP==1'b1) && (LastSSP==1'b1))begin
			SPU<=SPU;
		end
		else begin
			SPU<=SPU;
		end
	end
end

assign PC_MODE[1] = ((RET==1'b1)|| (CALL==1'b1)) ? stk_flag: 1'b0;
assign PC_MODE[0] = (RET==1'b1) ? stk_flag: 1'b0;
assign STK_CLK = 
(F2==1'b1)&&((CALL==1'b1)||(RET==1'b1)||(JMP==1'b1))? 1'b1: 1'b0;
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
			if((JMP==1'b1)&&(LastSSP==1'b0))begin
				{PU,PL} <= {PU,nowCMD[5:0]};
			end
			else if((CALL==1'b1)&&(LastSSP==1'b0))begin
				{PU,PL} <= {4'b1111,nowCMD[5:0]};
			end
			else if((nowCMD[7]==1'b1)&&(LastSSP==1'b1))begin
				{PU,PL} <= {SPU,nowCMD[5:0]};
			end
			else if(RET==1'b1)begin
				{PU,PL} <= PTR_STACK;
			end
			else begin{PU,PL}<= {PU,PL}; end
		end
	end
end 


assign PC_HL = PC_MUX? {PU,PL[5]}:PL[4:0];

//----------------
reg[3:0] ACC;
wire[3:0] ALU_OUT;
reg CC,CC2;
wire[3:0] AtoRAM;
wire[3:0] RAMtoA,ALU_INA,ALU_INB;
wire RAM_WR_CMD;
wire CIN,COUT;

assign ALU_INB = ((ADX==1'b1)||(DAA==1'b1))? nowCMD[3:0]: RAMtoA;
assign ALU_INA = (CADCSC==1'b1) ? ~ACC:ACC;

FULLADDER4 main_ALU
(
.Ain(ALU_INA),
.Bin(ALU_INB),
.Cin(CIN),
.Sout(ALU_OUT),
.Cout(COUT)
);

assign RAM_WR_CMD =(
((LAM==1'b1) && (LastLAM==1'b1)) ||
(SMP ==1'b1)||
( RMP==1'b1)||
( EXC==1'b1)||
( EXCI==1'b1)||
( EXCD==1'b1)
) 
? 1'b1: 1'b0;
// ACC groups

assign CIN =(( ADC==1'b1)||
( ADT==1'b1)||
( CADCSC==1'b1)
)? CC: 1'b0 ;


always @(posedge F2 or negedge RESET)
begin
	if(RESET == 1'b0) begin ACC<=4'b0000; end
	else  begin
		if(( LDA==1'b1)||( EXC==1'b1)||( EXCI==1'b1)||(  EXCD==1'b1)) 
		//if(( LDA==1'b1)||( EXC==1'b1)) 
			begin ACC<=RAMtoA; end
		else if(( ADC==1'b1)||( ADD==1'b1)||( CADCSC==1'b1)||( ADT==1'b1)||( ADX==1'b1)) 
			begin ACC<=ALU_OUT; end
		else if(( DAA==1'b1)&&((ACC>=4'b1010)||(CC==1'b1))) 
			begin ACC<=ALU_OUT; end
		else if(( LAM==1'b1)&&(LastLAM==1'b0)) 
			begin ACC<=nowCMD[3:0];end
		else if( KTA==1'b1)
			begin ACC<=KIN;end
		else 
			begin ACC<=ACC; end
	end
end

always @(posedge F2 or negedge RESET)
begin
	if(RESET == 1'b0)begin CC<=1'b0; end
	else begin
		if( RSC==1'b1)begin
			CC<=nowCMD[0];
		end
	//	else if( SC==1'b1)begin
	//		CC<=1'b1;
	//	end
		else if( ADC==1'b1 ||  CADCSC==1'b1 ||  ADT==1'b1 )begin
			CC<=COUT;
		end
		else if ( ( DAA==1'b1) &&((ACC>=4'd10)||(CC==1'b1)) )
			CC<=1'b1;
		else begin CC<=CC; end
	end
end 

always @(posedge F2)
begin
	if( ADX==1'b1)begin CC2<=COUT; end
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

assign AtoRAM=(RMP==1'b1)? (RAMtoA & (~CD4555_decode) ) :(SMP==1'b1)? (RAMtoA | CD4555_decode ) :(LAM==1'b1)? nowCMD[3:0] : ACC ;

// RAM groups
reg[3:0] BL;
reg[1:0] BU;


always @(posedge F2 or negedge RESET)begin
	if(RESET==1'b0)begin
		{BU,BL} <= 6'b000000;
	end
	else begin
		if((( EXC==1'b1) || ( LDA==1'b1)))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),BL};
		end
		else if(( EXCI==1'b1))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),(BL + 4'b0001)};
		end
		else if(( EXCD==1'b1))begin
			{BU,BL}<={(BU ^ nowCMD[1:0]),(BL + 4'b1111)};
		end
		else if(( INCB==1'b1))begin
			{BU,BL}<={BU,(BL + 4'b0001)};
		end
		else if(( DECB==1'b1))begin
			{BU,BL}<={BU,(BL + 4'b1111)};
		end
		else if((( LAM==1'b1)&&(LastLAM==1'b1)))begin
			{BU,BL}<={BU,(BL + 4'b0001)};
		end
		else if(( LB==1'b1)&&(LastLB==1'b0))begin
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
					begin {BU,BL}<={nowCMD[1:0],4'b1111}; end
			end
			else begin
				{BU,BL}<={nowCMD[1:0],4'b1100};
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
.RAM_clk(RAM_WR),
.dout(RAMtoA)	
);

wire NRF;
// SKIP group
assign NRF = (
(( TC==1'b1)&&(CC==1'b0)) ||
(( CADCSC==1'b1)&&(CC==1'b1)) ||
(( TAM==1'b1)&&(ACC==RAMtoA)) ||
(( ADT==1'b1)&&(CC==1'b0)) ||
(( EXCI==1'b1)&&(LastBL==4'b1011)) ||
(( EXCD==1'b1)&&(LastBL==4'b0000)) ||
(( INCB==1'b1)&&(LastBL==4'b1011)) ||
(( DECB==1'b1)&&(LastBL==4'b0000)) ||
(( SKZ==1'b1)&&(Zreg==1'b1)) ||
(( ADX==1'b1)&&(CC2==1'b0)) ||
(( SKMP==1'b1)&&(nowCMD[1:0]==2'b00)&&(RAMtoA[0]==1'b1)) ||
(( SKMP==1'b1)&&(nowCMD[1:0]==2'b01)&&(RAMtoA[1]==1'b1)) ||
(( SKMP==1'b1)&&(nowCMD[1:0]==2'b10)&&(RAMtoA[2]==1'b1)) ||
(( SKMP==1'b1)&&(nowCMD[1:0]==2'b11)&&(RAMtoA[3]==1'b1)) ||
((RET==1'b1)&&(nowCMD[0]==1))
) ? 1'b0:1'b1;

// Zreg group
reg Zreg;
always @(posedge F2 or negedge RESET)
begin
	if(RESET==1'b0)begin Zreg <= 1'b0;end
	else begin
		if(( RSZ==1'b1))begin Zreg <= nowCMD[3];end
		//else if(( RZ==1'b1))begin Zreg <= 1'b0;end
		else  begin Zreg<= Zreg;end
	end 
end

// other drives
assign ND = 
	((SHD==1'b1)||( RNP==1'b1)||( SNP==1'b1)) ? (~F2): 1'b1;

// Lreg group
reg[3:0] Lreg;

//assign nL = PU;
always @(posedge F2 or negedge RESET)
begin
	if(RESET==1'b0)begin
		Lreg <= 4'b0000;
	end
	else begin
		if((( ATL==1'b1)||( SNP==1'b1)))begin
			Lreg <= ACC;
		end
		else if( RNP==1'b1)begin
			Lreg <= 4'b0000;
		end
		else begin  Lreg<=Lreg; end
	end
end

assign nL = ~Lreg;

//****G 

endmodule

/*
module DG0045_RAM_256bit(
           input   wire RAM_clk  ,
           input   wire[5:0] addr ,
           input   wire[3:0]din  ,
           output wire[3:0]dout
          );
 
reg [3:0] mem [0:63];
 
always @(posedge RAM_clk)
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
	
	reg[9:0] SPA;
	reg[9:0] SPB;
	reg[9:0] SPC;
	reg[9:0] SPD;
	
	assign PL1NXR0 = (PC[0]==PC[1]) ? 1'b1:1'b0;
	assign SP = SPA;
	

always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPD<= SPC;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPD <= SPD;
		end
		else begin
			SPD <= SPD;
		end
	end

always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPC<= SPB;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPC <= SPD;
		end
		else begin
			SPC <= SPC;
		end
	end

always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPB<= SPA;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPB<= SPC;
		end
		else begin
			SPB<= SPB;
		end
	end

always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPA <=PC;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPA<= SPB;
		end
		else begin
			SPA<= SPA;
		end
	end
endmodule
*/
