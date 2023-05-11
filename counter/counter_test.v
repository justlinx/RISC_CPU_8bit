`timescale 1ns / 1ns

module counter_mux;

wire [4:0]cnt;
reg  [4:0]data;
reg  rst_n;
reg  clk;

counter c1(
     .clk(clk),
     .rst_n(rst_n),
     .data(data)
     .load(load)
     .cnt(cnt)
);

initial begin
     clk = 0;
     forever begin
          #10 clk = ~clk;
     end
end

initial begin
     $timeforamt(-9, 1, "ns", 9);
     $monitor("time = %t , data = %h , clk = %b , rst_n = %b , load = %b , cnt = %b ", $stime , data , clk , rst_n , load , cnt);
     $dumpvars(2 , counter_test);
end

task expect;
input [4:0] expects;
     if( cnt != expects ) begin
          $display ("At time %t cnt is %b and should be %b and should be %b", $time ,cnt , expects);
          $display ( "TEST FAILED") ;
     end
endtask

initial begin 
     @(negedge clk );
     //RESET
     {rst_n , load , data} = 7'b0_x_xxxxx; @(negedge clk ) expects (5'h00);
     //LOAD 1D
     {rst_n , load , data} = 7'b1_1_11101; @(negedge clk ) expects (5'h1D);
     //COUNT +5,ALSO TEST OVERFLOW
     {rst_n , load , data} = 7'b1_0_11101;
     repeat(5) @(negedge clk ) ;
     expects (5'h02);
     //LOAD 1F
     {rst_n , load , data} = 7'b1_1_11111; @(negedge clk ) expects (5'h1F);
     //RESET
     {rst_n , load , data} = 7'b0_x_xxxxx; @(negedge clk ) expects (5'h00);

     $display("TEST PASSED");
     $finish;
end
endmodule