module counter(
     input     clk,
     input     rst_n,
     input     load,
     input     [4:0] data,
     output    reg [4:0] cnt
     );
     
always @(posedge clk or negedge rst_n)begin
     if(!rst_n) cnt<='b0;
     else if(load) cnt<=data;
     else cnt<=cnt+1;
end

endmodule