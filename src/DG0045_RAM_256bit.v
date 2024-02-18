module DG0045_RAM_256bit(
           input   wire RAM_clk  ,
           input   wire[5:0] addr ,
           input   wire[3:0]din  ,
           output wire[3:0]dout
          );
 
//reg [3:0] mem [0:63];
           reg [3:0] mem [0:15];
always @(posedge RAM_clk)
begin
        mem [addr[3:0]] <= din;
end

           assign   dout = mem [addr[3:0]] ;

endmodule
