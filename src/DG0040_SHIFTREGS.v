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
	reg[9:0] SPE;
	
	assign PL1NXR0 = (PC[0]==PC[1]) ? 1'b1:1'b0;
	assign SP = SPA;
	
	always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPE<= SPD;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPE<= SPE;
		end
		else begin
			SPE<=SPE;
		end
	end

always @(posedge STK_CLK)begin
		if((MODE1== 1'b1)&&( MODE0==1'b0)) begin
			SPD<= SPC;
		end
		else if((MODE1==1'b1 )&&( MODE0==1'b1)) begin	
			SPD <= SPE;
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
