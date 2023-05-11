`timescale 1ns / 1ns
module register (
     input     clk,
     input     rst_n,
     input     load,
     input     [7:0] data,
     output    [7:0] out
);
     wire [7:0] n1 , n2;
     mux m0(
          .sel (load   ),
          .b   (data[0]),
          .a   (out[0] ), 
          .out (n1[0]   )
     );
     mux m1(
          .sel (load   ),
          .b   (data[1]),
          .a   (out[1] ), 
          .out (n1[1]   )
     );
     mux m2(
          .sel (load   ),
          .b   (data[2]),
          .a   (out[2] ), 
          .out (n1[2]   )
     );
     mux m3(
          .sel (load   ),
          .b   (data[3]),
          .a   (out[3] ), 
          .out (n1[3]   )
     );
     mux m4(
          .sel (load   ),
          .b   (data[4]),
          .a   (out[4] ), 
          .out (n1[4]   )
     );
     mux m5(
          .sel (load   ),
          .b   (data[5]),
          .a   (out[5] ), 
          .out (n1[5]   )
     );
     mux m6(
          .sel (load   ),
          .b   (data[6]),
          .a   (out[6] ), 
          .out (n1[6]   )
     );
     mux m7(
          .sel (load   ),
          .b   (data[7]),
          .a   (out[7] ), 
          .out (n1[7]   )
     );
     dffr d0(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[0]  ),
          .q    (out[0])
     );
     dffr d1(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[1]  ),
          .q    (out[1])
     );
     dffr d2(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[2]  ),
          .q    (out[2])
     );
     dffr d3(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[3]  ),
          .q    (out[3])
     );
     dffr d4(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[4]  ),
          .q    (out[4])
     );
     dffr d5(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[5]  ),
          .q    (out[5])
     );
     dffr d6(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[6]  ),
          .q    (out[6])
     );
     dffr d7(
          .clk  (clk   ),
          .rst_n(rst_n ),
          .d    (n1[7]  ),
          .q    (out[7])
     );     
endmodule
