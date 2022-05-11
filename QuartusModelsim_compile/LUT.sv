// Design Name:    CSE141L
// Module Name:    LUT

// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
// in general, Output = f(Input)
//
// Lots of potential applications of LUTs!!

// You might consider parameterizing this!
module LUT(
  input        [ 3:0] Addr,
  output logic [ 9:0] Target
);

always_comb begin

  case(Addr)
    4'b0000: Target = 10'h3f0; // -16, i.e., move back 16 lines of machine code
    4'b0001: Target = 10'h003;
    4'b0010: Target = 10'h007;
    4'b0011: Target = 10'h001; // default to 1 (or PC+1 for relative)
	 4'b0100: Target = 10'h3f0; // -16, i.e., move back 16 lines of machine code
    4'b0101: Target = 10'h003;
    4'b0110: Target = 10'h007;
    4'b0111: Target = 10'h001; // default to 1 (or PC+1 for relative)
    4'b1000: Target = 10'h3f0; // -16, i.e., move back 16 lines of machine code
    4'b1001: Target = 10'h003;
    4'b1010: Target = 10'h007;
    4'b1011: Target = 10'h001; // default to 1 (or PC+1 for relative)	 
    4'b1100: Target = 10'h3f0; // -16, i.e., move back 16 lines of machine code
    4'b1101: Target = 10'h003;
    4'b1110: Target = 10'h007;
    4'b1111: Target = 10'h001; // default to 1 (or PC+1 for relative)	  
  endcase
end

endmodule
