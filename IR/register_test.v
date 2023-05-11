`timescale 1ns / 1ns
module register_test;
     wire [7:0] out;
     reg  [7:0]data;
     reg       load;
     reg      rst_n;
     reg        clk;
     //Instantiate register
     register u_register(
          .out  ( out ),
          .data ( data),
          .clk  ( clk ),
          .rst_n(rst_n),
          .clk  ( clk )
     );
     //Instantiate clock
     clock u_clock (
          .clk (clk)
     );
     //Monitor signals
     initial begin
     $timeforamt(-9, 1, "ns", 9);
     $monitor("time = %t , clk = %b , data = %h , load = %b , out = %h ", $stime , $time , data , load , out);
     $dumpvars(2 , register_test);
end
     //Apply stimulus 
     initial begin
     //To prevent the races of clock/data,don't tansition the stimulus on the active(posedge)edge of the clock
     @ (negedge clk )//Initialize signals
     rst_n = 0;
     data  = 0;
     load  = 0;

     @ (negedge clk )//Relase reset
     rst_n = 1;

     @ (negedge clk )//Load hex 55
     data = 8'h55;
     load = 1;

     @ (negedge clk )//Load hex AA
     data = 8'hAA;
     load = 1;

     @ (negedge clk )//Disable load but register data
     data = 8'hcc;
     load = 0;

     @ (negedge clk )//Terminate simulation
     $finish
     end
endmodule
