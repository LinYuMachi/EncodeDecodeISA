`timescale 1ns/ 1ps

// Test bench
// Arithmetic Logic Unit

//
// INPUT: A, B
// op: 000, A ADD B
// op: 100, A_AND B
// ...
// Please refer to definitions.sv for support ops (make changes if necessary)
// OUTPUT A op B
// equal: is A == B?
// even: is the output even?
//

module ALU_tb;

// Define signals to interface with the ALU module
logic [ 7:0] R0;  // data inputs
logic [ 7:0] Input;
logic [ 3:0] op;      // ALU opcode, part of microcode
bit Mode = 'b0;
logic C_out;
wire[ 7:0] OUT;
wire Zero;

// Define file
integer fd;

// Define a helper wire for comparison
logic [ 7:0] expected;

// Instatiate and connect the Unit Under Test
ALU uut(
  .R0(R0),
  .Input(Input),
  .Mode(Mode),
  .OP(op),
  .C_out(C_out),
  .Out(OUT),
  .Zero(Zero)
);


// The actual testbench logic
initial begin
  // create a new file
  fd = $fopen("test_file.txt","a");
  $fdisplay(fd,"Start Testing:");
  Mode = 0;
  // test for lookup
  R0 = 1;
  Input = 10;
  op = 'b0000;
  test_alu_func;
  #5;
  // test for load
  R0 = 1;
  Input = 10;
  op = 'b0001;
  test_alu_func;
  #5;
  // test for add
  R0 = 1;
  Input = 1;
  op= 'b0010; 
  test_alu_func;
  #5;
  // test for add overflow
  R0 = 8'b10000000;
  Input = 8'b10000000;
  op= 'b0010; 
  test_alu_func; 
  #5;
  // test for sub
  R0 = 2;
  Input = 1;
  op = 'b0011;
  test_alu_func;
  #5;
  // test for move
  R0 = 1;
  Input = 2;
  op = 'b0100;
  test_alu_func;
  #5;
  // test for load
  R0 = 1;
  Input = 2;
  op = 'b0101;
  test_alu_func;
  #5;
  // test for store
  R0 = 1;
  Input = 2;
  op = 'b0110;
  #5;
  // test for shift left
  R0 = 8'b00000010;
  Input = 8'b00000001;
  op = 'b0111;
  test_alu_func;
  #5;
  // test for shift right
  R0 = 8'b00000001;
  Input = 8'b00000010;
  op = 'b1000;
  test_alu_func;
  #5;
  // test for and
  R0 = 8'b00000101;
  Input = 8'b00000011;
  op = 'b1001;
  test_alu_func;
  #5;
  // test for xor
  R0 = 8'b0000101;
  Input = 8'b00000011;
  op = 'b1010;
  test_alu_func;
  #5;  
  // test for equal
  R0 = 8'b00000011;
  Input = 8'b00000011;
  op = 'b1011;
  test_alu_func;
  #5; 	
  // test for not equal
  R0 = 8'b00000001;
  Input = 8'b00000011;
  op = 'b1011;
  test_alu_func;
  #5; 	 	
  // test for less
  R0 = 8'b00000001;
  Input = 8'b00000011;
  op = 'b1100;
  test_alu_func;
  #5; 	
  // test for not less
  R0 = 8'b00000011;
  Input = 8'b00000011;
  op = 'b1100;
  test_alu_func;
  #5; 	
  // test for greater
  R0 = 8'b00000011;
  Input = 8'b00000001;
  op = 'b1101;
  test_alu_func;
  #5; 	
  // test for not greater
  R0 = 8'b00000011;
  Input = 8'b00000011;
  op = 'b1101;
  test_alu_func;
  #5;
  // test for branch on 0
  Mode = 1;
  R0 = 0;
  Input = 8'b11111111;
  op = 'b1111;
  test_alu_func;
  #5;
  // test for not branch on 1
  R0 = 1;
  Input = 8'b11111111;
  op = 'b1111;
  test_alu_func;
  #5;
  // close file
  #10 $fclose(fd);
end

task test_alu_func;
  case (op)
    //0000: lookup 
	 0: expected =  Input;
	 //0001: load from reg to accumulator
	 1: expected = Input; // move value from Reg   to R0
	 //0010: add
	 2: {C_out,expected} = {1'b0,R0} + Input;
	 //0011: sub
	 3: expected = R0 - Input;
	 //0100: move from accumulator to reg
	 4: expected = R0; // move value from R0 to Reg
	 //0101: load from memory
	 5: expected = Input;
	 //0110: store to memory
	 6: expected = Input;
	 //0111: shift left
	 7: expected = Input << 1;
	 //1000: shift right
	 8: expected = Input >> 1;
	 //1001: and
	 9: expected = R0 & Input;
	 //1010: xor
	 10: expected = R0 ^ Input;
	 //1011: check if equal
	 11: begin
	 if (R0 == Input)
		expected = 1;
	 else
		expected = 0;
	 end
	 //1100: check if less than
	 12: begin
	 if (R0 < Input)
		expected = 1;
	 else
		expected = 0;
	 end
	 //1101: check if greater than
	 13: begin
	 if (R0 > Input)
		expected = 1;
	 else
		expected = 0;
	 end  
	//check branch on 0
	15: begin 
	if (R0 == 'b0)
		expected = Input;
	else
		expected = 0;		
	end
  endcase
  #1;
  if(expected == OUT) begin
    $fdisplay(fd, "%t YAY!! R0, inputs = %b and %b, opcode = %b, Output = %b, C_out = %b",$time, R0,Input,op, OUT, C_out);
  end else begin
    $fdisplay(fd, "%t FAIL! R0, inputs = %b and %b, opcode = %b, Output = %b, C_out = %b",$time, R0,Input,op, OUT, C_out);
  end
endtask

initial begin
  $dumpfile("alu.vcd");
  $dumpvars();
  $dumplimit(104857600); // 2**20*100 = 100 MB, plenty.
end

endmodule
