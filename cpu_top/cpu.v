`timescale 1ns / 1ns

module cpu(
     input     rst_n
);
     wire [7:0] data ; 
     wire [7:0] alu_out ; 
     wire [7:0] ir_out ; 
     wire [7:0] ac_out ; 
     wire [4:0] pc_addr ; 
     wire [4:0] ir_addr ; 
     wire [4:0] addr ; 
     wire [2:0] opcode ; 

     assign opcode  = ir_out[7:5];
     assign ir_addr = ir_out[4:0];

     control ctl0(
          .rd(rd),
          .wr(wr),
          .ld_ir(ld_ir),
          .ld_ac(ld_ac),
          .ld_pc(ld_pc),
          .inc_pc(inc_pc),
          .halt(halt),
          .data_e(data_e),
          .sel(sel),
          .opcode(opcode),
          .zero(zero),
          .clk(clock), 
          .rst_n(rst_n)
     );

     alu alu0(
          .out(alu_out),
          .zero(zero),
          .opcode(opcode),
          .data(data),
          .accum(ac_out)
     );

     register ac(             //累加器
          .out(ac_out),
          .data(alu_out),
          .load(ld_ac),
          .clk(clock),
          .rst_n(rst_n)
     );

     register ir(             //IR寄存器
          .out(ir_out),
          .data(data),
          .load(ld_ir),
          .clk(clock),
          .rst_n(rst_n)
     );

     scale_mux #5 smx(
          .out(addr),
          .sel(sel),
          .b(pc_addr),
          .a(ir_addr)
     );

     mem mem0(
          .data(data),
          .addr(addr),
          .read(rd),
          .write(wr)
     );

     counter pc(              //程序计数器
          .cnt(pc_addr),
          .data(ir_addr),
          .load(ld_pc),
          .clk(inc_pc),
          .rst_n(rst_n)
     );

     clock clk(               //时钟源
          .clk(clock)
     );

     assign data = (data_e) ? alu_out : 8'bz ;
endmodule
