`timescale 1ns / 1ns
module scale_mux
#(
     parameter size = 1 
)
(
     input      [size-1:0] a , b ,
     input      sel ,
     output     [size-1:0] out
);

     assign out = ( !sel ) ? a :( sel ) ? b : { size{1'bx} };

endmodule
