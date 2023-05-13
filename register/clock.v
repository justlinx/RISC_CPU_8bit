`timescale 1ns / 1ns
module clkgen(
     output reg clk
);
initial begin
     clk = 1;
     forever begin 
         #5 clk = 0;
         #5 clk = 1;
     end
end
endmodule 
