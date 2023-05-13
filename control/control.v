`timescale 1ns / 1ns
`define   HLT  3'b000
`define   SKZ  3'b001
`define   ADD  3'b010 
`define   AND  3'b011 
`define   XOR  3'b100 
`define   LDA  3'b101 
`define   STO  3'b110 
`define   JMP  3'b111 
module control(
     input     [2:0] opcode,
     input     zero,
     input     rst_n,
     input     clk,

     output reg rd,
     output reg wr,
     output reg ld_ir,
     output reg ld_ac,
     output reg ld_pc,
     output reg inc_pc,
     output reg halt,
     output reg data_e,
     output reg sel
);
     reg [2:0] state,next_state;

     //三段式状态机写法
     always @(posedge clk or negedge rst_n )begin
          if(!rst_n)
               state <= 3'b000;
          else 
               state <= next_state;
     end

     always @(negedge clk) begin//建议使用格雷码编码，否则综合不过，独热码也可以，但综合效率低
          case(state) 
               3'b000 : next_state <= 3'b001; 
               3'b001 : next_state <= 3'b011 ; 
               3'b011 : next_state <= 3'b010 ; 
               3'b010 : next_state <= 3'b110 ; 
               3'b110 : next_state <= 3'b111 ; 
               3'b111 : next_state <= 3'b101 ; 
               3'b101 : next_state <= 3'b100 ; 
               3'b100 : next_state <= 3'b000 ; 
          endcase 
     end 
     always @(opcode or state or zero)
     begin:blk 
          reg alu_op; 
          alu_op = opcode==`ADD||opcode==`AND||opcode==`XOR||opcode==`LDA;

          case (state)
               3'b000:begin
                    sel    <= 1'b0;
                    rd     <= alu_op;
                    ld_ir  <= 1'b0;
                    inc_pc <= opcode==`SKZ & zero || opcode==`JMP; 
                    halt   <= 1'b0;
                    ld_pc  <= opcode==`JMP; 
                    data_e <= !alu_op;
                    ld_ac  <= alu_op; 
                    wr     <= opcode==`STO;
               end
               3'b001:begin  
                    sel    <= 1'b1; 
                    rd     <= 1'b0; 
                    ld_ir  <= 1'b0; 
                    inc_pc <= 1'b0; 
                    halt   <= 1'b0; 
                    ld_pc  <= 1'b0; 
                    data_e <= 1'b0; 
                    ld_ac  <= 1'b0; 
                    wr     <= 1'b0; 
               end 
               3'b011:begin 
                    sel    <= 1'b1; 
                    rd     <= 1'b1; 
                    ld_ir  <= 1'b0; 
                    inc_pc <= 1'b0; 
                    halt   <= 1'b0; 
                    ld_pc  <= 1'b0; 
                    data_e <= 1'b0; 
                    ld_ac  <= 1'b0; 
                    wr     <= 1'b0; 
               end
               3'b010:begin 
                    sel    <= 1'b1; 
                    rd     <= 1'b1; 
                    ld_ir  <= 1'b1; 
                    inc_pc <= 1'b0; 
                    halt   <= 1'b0; 
                    ld_pc  <= 1'b0; 
                    data_e <= 1'b0; 
                    ld_ac  <= 1'b0; 
                    wr     <= 1'b0; 
               end
               3'b110:begin 
                    sel    <= 1'b0; 
                    rd     <= 1'b0; 
                    ld_ir  <= 1'b0; 
                    inc_pc <= 1'b1; 
                    halt   <= opcode==`HLT; 
                    ld_pc  <= 1'b0; 
                    data_e <= 1'b0; 
                    ld_ac  <= 1'b0; 
                    wr     <= 1'b0; 
               end  
               3'b111:begin 
                    sel    <= 1'b0; 
                    rd     <= alu_op; 
                    ld_ir  <= 1'b0; 
                    inc_pc <= 1'b0; 
                    halt   <= 1'b0; 
                    ld_pc  <= 1'b0; 
                    data_e <= 1'b0; 
                    ld_ac  <= 1'b0; 
                    wr     <= 1'b0; 
               end
               3'b100:begin 
                    sel    <= 1'b0; 
                    rd     <= alu_op; 
                    ld_ir  <= 1'b0; 
                    inc_pc <= opcode==`SKZ & zero; 
                    halt   <= 1'b0; 
                    ld_pc  <= opcode==`JMP;
                    data_e <= !alu_op;
                    ld_ac  <= alu_op; 
                    wr     <= opcode==`STO;
               end
          default:;
          endcase
     end
endmodule