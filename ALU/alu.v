`timescale 1ns / 1ns
module alu(
     input      [7:0] data,
     input      [7:0] accum,
     input      [2:0] opcode,
     output reg [7:0] out,
     output reg zero
);
     //parameter define
     parameter PASS0 = 3'b000 ;
     parameter PASS1 = 3'b001 ;
     parameter  ADD  = 3'b010 ;
     parameter  AND  = 3'b011 ;
     parameter  XOR  = 3'b100 ;
     parameter PASSD = 3'b101 ;
     parameter PASS6 = 3'b110 ;
     parameter PASS7 = 3'b111 ;

     always @(*) begin
          case (opcode)
               PASS0 : out = accum ;
               PASS1 : out = accum ;
                 ADD : out = accum + data ;
                 AND : out = accum & data ;
                 XOR : out = accum ^ data ;
               PASSD : out = data  ;
               PASS6 : out = accum ;
               PASS7 : out = accum ;
             default : out = 8'bx  ;
          endcase             
     end

     always @(*) begin
          if (out == 0) begin
               zero = 1'b1 ;
          end else begin
               zero = 1'b0 ;
          end
     end

endmodule
