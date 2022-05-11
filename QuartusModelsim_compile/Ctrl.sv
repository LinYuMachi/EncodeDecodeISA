// Project Name:   CSE141L
// Module Name:    Ctrl
// Create Date:    ?
// Last Update:    2022.01.13

// control decoder (combinational, not clocked)
// inputs from ... [instrROM, ALU flags, ?]
// outputs to ...  [program_counter (fetch unit), ?]
//import Definitions::*;

// n.b. This is an example / starter block
//      Your processor **will be different**!
module Ctrl (
  input  [8:0] Instruction,    // machine code
                               // some designs use ALU inputs here
  output logic 		Mode,
  output logic       	Branch, // branch at all?
                     	RegWrEn,  // write to reg_file (common)
			RegWrR0,  // write to accumulator Reg0
                     	MemWrEn,  // write to mem (store only)
			MemRdEn,  // read from mem
			LoadInst, // selects memory vs ALU output 
                    	start,    // in case we run programs in seq
			lookup,   // control lookup table
			Ack	//"done with program"
);

logic [3:0]opcode;
//// What follows is instruction decoding.
//// This codifies much of your ISA definition!
////
//// Note: This **starter code** is not a complete ISA!
//assign Mode = Instruction[8];
assign opcode = Instruction[7:4];
assign Mode = Instruction[8];

always_comb begin
  if (Mode == 1'b0) begin
    Branch = 0;
    case(opcode)
	  0: begin
		RegWrEn = 0;
		RegWrR0 = 0;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 1;
	  end	
		
	  1: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			

	  2: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end	

	  3: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end		  
		
	  4: begin
		RegWrEn = 1;
		RegWrR0 = 0;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  5: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 1;
		start = 0;
		lookup = 0;
	  end			
		
	  6: begin
		RegWrEn = 0;
		RegWrR0 = 0;
		MemWrEn = 1;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  7: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  8: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  9: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  10: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  11: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  12: begin 
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
		
	  13: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
	  end			
	
	  default: begin
		RegWrEn = 0;
		RegWrR0 = 1;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;	  
	  end
    endcase		
  end 
  else begin
		Branch = 1;
		RegWrEn = 0;
		RegWrR0 = 0;
		MemWrEn = 0;
		MemRdEn = 0;
		start = 0;
		lookup = 0;
  end
end
//// instruction = 9'b110??????;
//assign MemWrEn = Instruction[8:6] == 3'b110;

//assign RegWrEn = Instruction[8:7] != 2'b11;
//assign LoadInst = Instruction[8:6] == 3'b011;

//// reserve instruction = 9'b111111111; for Ack
assign Ack = &Instruction;

assign LoadInst = Instruction[7:4] == 4'b0101;

//// jump on right shift that generates a zero
//// equiv to simply: assign Jump = Instruction[2:0] == RSH;
//always_comb begin
//  if(Instruction[2:0] == RSH) begin
//    Jump = 1;
//  end else begin
//    Jump = 0;
//  end
//end

//// branch every time instruction = 9'b?????1111;
//assign BranchEn = &Instruction[3:0];

//// Maybe define specific types of branches?
//assign TargSel  = Instruction[3:2];

endmodule
