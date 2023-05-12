`timescale 1ns / 1ns 

//Define the dealy from stimulus to response check
`define DELAY 20

module alu_test();

     wire zero;
     wire [7:0] out ;
     reg  [7:0] data;
     reg  [7:0] accum;
     reg  [2:0] opcode;
     integer i;

     //Define opcodes
     parameter PASS0 = 3'b000 ,
               PASS1 = 3'b001 ,
                 ADD = 3'b010 ,
                 AND = 3'b011 ,
                 XOR = 3'b100 ,
               PASSD = 3'b101 ,
               PASS6 = 3'b110 ,
               PASS7 = 3'b111 ;
     //Instantiate the ALU
     //Use explicit port connections
     alu alu0 ( 
               .out(out),
               .zero(zero),
               .opcode(opcode),
               .accum(accum),
               .data(data)
     );

     //Monitor the signals
     initial begin
          $display   ("<-----------------INPUTS-----------------><------OUTPUTS-------->");
          $display   ("  TIME     OPCODE    DATA  IN   ACCIM  IN    ALU OUT    ZERO  BIT");
          $display   ("--------   ------   ---------- -----------  ---------   ---------");
          $timeformat(-9, 1, " ns", 9);
          $dumpvars  (2,alu_test);
     end

     //Verify response
     task expect;
     input [8:0] expects;
          begin
               $display ("%t    %b  %b  %b  %b  %b", $time, opcode, data, accum, out, zero);
               if ( {zero, out} !== expects ) begin
                    $display ("At time %t: zero is %b and should be %b , out is %b and should be %b", $time, zero, expects[8], out, expects[7:0]);
                    $display ("Test failed");
                    $finish;
               end
          end
     endtask
     //Apply stimulus
     initial begin
          { opcode, accum, data } = { PASS0, 'h00, 'hFF }; #(`DELAY) expect ({1'b1,accum});
          { opcode, accum, data } = { PASS0, 'h55, 'hFF }; #(`DELAY) expect ({1'b0,accum});
          { opcode, accum, data } = { PASS1, 'h55, 'hFF }; #(`DELAY) expect ({1'b0,accum});
          { opcode, accum, data } = { PASS1, 'hCC, 'hFF }; #(`DELAY) expect ({1'b0,accum});
          { opcode, accum, data } = { ADD,   'h33, 'hAA }; #(`DELAY) expect ({1'b0,accum+data});
          { opcode, accum, data } = { AND,   'h0F, 'hAA }; #(`DELAY) expect ({1'b0,accum&data});
          { opcode, accum, data } = { XOR,   'hF0, 'h55 }; #(`DELAY) expect ({1'b0,accum^data});
          { opcode, accum, data } = { PASSD, 'h00, 'hAA }; #(`DELAY) expect ({1'b1,data});
          { opcode, accum, data } = { PASSD, 'h00, 'hCC }; #(`DELAY) expect ({1'b1,data});
          { opcode, accum, data } = { PASSD, 'hFF, 'h00 }; #(`DELAY) expect ({1'b0,data});
          { opcode, accum, data } = { PASS6, 'hFF, 'hF0 }; #(`DELAY) expect ({1'b0,accum});
          { opcode, accum, data } = { PASS7, 'hCC, 'h0F }; #(`DELAY) expect ({1'b0,accum});
          $display ("Test failed");
          $finish;
     end

endmodule 
