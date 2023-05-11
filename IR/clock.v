`timescale 1ns / 1ns
module clock(
     output reg clk
);
initial begin
     clk = 0;
     forever 
         #10 clk = ~clk;
end
endmodule 