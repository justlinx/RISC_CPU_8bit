`timescale 1ns / 1ns

module mem (
     input     [4:0]addr,
     input     [4:0]data,
     input     read,
     input     write
);
     reg [7:0] memory [0:31];

     assign data = read ? memory[addr] : 8'bz ;
     
     always @(posedge write)begin
          memory[addr] = data; 
     end


endmodule
