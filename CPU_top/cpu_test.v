`timescale 1 ns / 1 ns

module cpu_test;  

  reg		rst_n	;
  reg [(3*8):1] mnemonic;


// Instantiate the VeriRISC CPU

  cpu cpu0 ( rst_n ) ;


// Generate mnemonic

  always @ ( cpu0.opcode )
    case ( cpu0.opcode )
      3'h0    : mnemonic = "HLT" ;
      3'h1    : mnemonic = "SKZ" ;
      3'h2    : mnemonic = "ADD" ;
      3'h3    : mnemonic = "AND" ;
      3'h4    : mnemonic = "XOR" ;
      3'h5    : mnemonic = "LDA" ;
      3'h6    : mnemonic = "STO" ;
      3'h7    : mnemonic = "JMP" ;
      default : mnemonic = "???" ;
    endcase


// Monitor signals

  initial
    begin
      $timeformat ( -9, 1, " ns", 12 ) ;
//      $shm_open ( "waves.shm" ) ;
//      $shm_probe ( mnemonic, cpu0, "A" ) ;
      $dumpvars (0,cpu_test);
    end


// Apply stimulus

  always
    begin
     `ifdef INCA
     $display("\n************************************************************");
     $display("*        THE FOLLOWING DEBUG TASKS ARE AVAILABLE:          *");
     $display("* Enter \"scope cpu_test; deposit test.N 1; task test; run\" *");
     $display("*         to run the 1st diagnostic program.               *");
     $display("* Enter \"scope cpu_test; deposit test.N 2; task test; run\" *");
     $display("*         to run the 2nd diagnostic program.               *");
     $display("* Enter \"scope cpu_test; deposit test.N 3; task test; run\" *");
     $display("*         to run the Fibonacci program.                    *");
     $display("************************************************************\n");
     `else
     $display("\n***********************************************************");
     $display("*        THE FOLLOWING DEBUG TASKS ARE AVAILABLE:         *");
     $display("* Enter \"call test(1);run\" to run the 1st diagnostic program.   *");
     $display("* Enter \"call test(2);run\" to run the 2nd diagnostic program.   *");
     $display("* Enter \"call test(3);run\" to run the Fibonacci program.        *");
     $display("***********************************************************\n");
     `endif
      $stop ;
      @ ( negedge cpu0.clock )
      rst_n = 0;
      @ ( negedge cpu0.clock )
      rst_n = 1;
      @ ( posedge cpu0.halt )
      $display ( "HALTED AT PC = %h", cpu0.pc_addr ) ;
      disable test ;
    end


// Define the test task

  task test ;
    input [1:0] N ;
    reg [12*8:1] testfile ;
    if ( 1<=N && N<=3 )
      begin
        testfile = { "CPUtest", 8'h30+N, ".dat" } ;
        $readmemb ( testfile, cpu0.mem0.memory ) ;
        case ( N )
          1:
            begin
              $display ( "RUNNING THE BASIC DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 17" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( cpu0.opcode or cpu0.ir_addr )
	        $strobe ( "%h %s   %h  %h   %h",
                   cpu0.pc_addr, mnemonic, cpu0.opcode, cpu0.data, cpu0.addr ) ;
            end
          2:
            begin
              $display ( "RUNNING THE ADVANCED DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 10" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( cpu0.opcode or cpu0.ir_addr )
	        $strobe ( "%h %s   %h  %h   %h",
                   cpu0.pc_addr, mnemonic, cpu0.opcode, cpu0.data, cpu0.addr ) ;
            end
            3:
              begin
                $display ( "RUNNING THE FIBONACCI CALCULATOR" ) ;
                $display ( "THIS PROGRAM SHOULD CALCULATE TO 144" ) ;
                $display ( "FIBONACCI NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( cpu0.opcode )
                  if (cpu0.opcode == 3'h7)
                    $strobe ( "%d", cpu0.mem0.memory[5'h1B] ) ;
              end
        endcase
      end
    else
      begin
        $display("Not a valid test number. Please try again." ) ;
        $stop ;
      end
  endtask

endmodule
