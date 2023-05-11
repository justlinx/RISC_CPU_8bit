`define width 8
`timescale 1ns/1ps

module mux_test;

reg  [`width-1:0] a, b ;
wire [`width-1:0] out;
reg  sel;

scale_mux mux1(.a(a), .b(b), .out(out), .sel(sel));

initial begin
//显示结果，并且存到SHM数据表中
     $monitor($stime , ,"sel = %b a=%b b=%b out=%b" , sel, a, b, out);
     $dumpvars(2,mux_test); 
//提供仿真信号
          sel = 0 ; a = { `width{1'b0} } ; b = { `width{1'b1} } ;
     #5   sel = 0 ; a = { `width{1'b1} } ; b = { `width{1'b0} } ;
     #5   sel = 1 ; a = { `width{1'b0} } ; b = { `width{1'b1} } ;
     #5   sel = 1 ; a = { `width{1'b1} } ; b = { `width{1'b0} } ;
     $finish;
end
endmodule