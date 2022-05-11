// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

// includes package "Definitions"
import Definitions::*;

module ALU #(parameter W=8, Ops=4)(
  input        [W-1:0]   R0,       // data inputs
                         Input,
  input        [Ops-1:0] OP,           // ALU opcode, part of microcode
  input                  Mode,        // shift or carry in
  output logic				 C_out,			// carry out
  output logic [W-1:0]   Out,          // data output
  output logic           Zero         // output = zero flag    !(Out)
//                         Parity,       // outparity flag        ^(Out)
//                         Odd           // output odd flag        (Out[0])
                         // you may provide additional status flags, if desired
);

// type enum: used for convenient waveform viewing
op_mne op_mnemonic;

always_comb begin
  // No Op = default
  // Out = 0;
  Out = 'b0;
  C_out = 1'b0;
if (~Mode) begin
  case(OP)
    //0000: lookup 
	 LK: Out =  Input;
	 //0001: load from reg to accumulator
	 LOAD: Out = Input; // move value from Reg to R0
	 //0010: add
	 ADD: {C_out,Out} = {1'b0,R0} + Input;
	 //0011: sub
	 SUB: Out = R0 - Input;
	 //0100: move from accumulator to reg
	 MOV: Out = R0; // move value from R0 to Reg
	 //0101: load from memory
	 LW: Out = Input;
	 //0110: store to memory
	 SW: Out = Input;
	 //0111: shift left
	 SL: Out = Input << 1;
	 //1000: shift right
	 SR: Out = Input >> 1;
	 //1001: and
	 AND: Out = R0 & Input;
	 //1010: xor
	 XOR: Out = R0 ^ Input;
	 //1011: check if equal
	 EQ: begin
	 if (R0 == Input)
		Out = 1;
	 else
		Out = 0;
	 end
	 //1100: check if less than
	 LT: begin
	 if (R0 < Input)
		Out = 1;
	 else
		Out = 0;
	 end
	 //1101: check if greater than
	 GT: begin
	 if (R0 > Input)
		Out = 1;
	 else
		Out = 0;
	 end
  endcase
end
else begin
	 // branch on 0
	 // if R0 is 0, branch out and output is the branching address
	 // else Output 0
	 if (R0 == 'b0)
		Out = Input;
	 else
		Out = 0;
end
end

assign Zero   = ~|Out;                  // reduction NOR
//assign Parity = ^Out;                   // reduction XOR
//assign Odd    = Out[0];                 // odd/even -- just the value of the LSB

// Toolchain guard: icarus verilog doesn't support this debug feature.
`ifndef __ICARUS__
always_comb
  op_mnemonic = op_mne'(OP);            // displays operation name in waveform viewer
`endif

endmodule
