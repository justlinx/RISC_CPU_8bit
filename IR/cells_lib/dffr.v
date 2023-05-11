`timescale 1ns / 1ns
`celldefine
module dffr(
     input     clk,
     input     rst_n,
     input     d,
     output    q,
     output    q_n
);
     nand n1 (de , dl  , qe);
     nand n2 (qe , clk , de , rst_n );
     nand n3 (dl , d   , d1_, rst_n );
     nand n4 (dl_, d1  , clk, qe    );
     nand n5 (q  , qe  , q_         );
     nand n6 (q_ , dl_ , q  , rst_n );
endmodule 
`endcelldefine