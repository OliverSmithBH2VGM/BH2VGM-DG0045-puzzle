/*module DG0045_RAM_256bit(
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

endmodule*/
module DG0045_RAM_128bit(
           input   wire RAM_clk  ,
           input   wire[4:0] addr ,
           input   wire[3:0]din  ,
           output wire[3:0]dout
          );
 
reg [3:0] mem [0:31];
 
always @(posedge RAM_clk)
begin
        mem [addr] <= din;
end

assign   dout = mem [addr] ;

endmodule
