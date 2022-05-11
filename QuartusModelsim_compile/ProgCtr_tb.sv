// Test bench
// Program Counter (Instruction Fetch)

module ALU_tb;

timeunit 1ns;

// Define signals to interface with UUT
bit Reset;
bit Start;
bit Clk;
bit Branch;
bit [9:0] TargetOrOffset;
logic [9:0] NextInstructionIndex;

// Instatiate and connect the Unit Under Test
ProgCtr uut (
  .Reset(Reset),
  .Start(Start),
  .Clk(Clk),
  .Branch(Branch),
  .Target(TargetOrOffset),
  .ProgCtr(NextInstructionIndex)
);

integer ClockCounter = 0;
integer fd;
always @(posedge Clk)
  ClockCounter <= ClockCounter + 1;

// The actual testbench logic
//
// In this testbench, let's look at 'manual clocking'
initial begin
  // Time 0 values
  fd = $fopen("test_progcrt.txt","a");
  $fdisplay(fd, "Initialize Testbench.");
  Reset = '1;
  Start = '0;
  Clk = '0;
  Branch = '0;
  TargetOrOffset = '0;
  //$fdisplay(fd, "%t ClockCounter = %d, Branch = %b, TargetOrOffset = %d, NextInstructionIndex = % d", $time, ClockCounter, Branch, TargetOrOffset, NextInstructionIndex);
  write2file;
  // Advance to simulation time 1, latch values
  #1 Clk = '1;

  // Advance to simulation time 2, check results, prepare next values
  #1 Clk = '0;
  $fdisplay(fd, "Checking Reset behavior");
  assert (NextInstructionIndex == 'd0);
  Reset = '0;
  write2file;

  // Advance to simulation time 3, latch values
  #1 Clk = '1;
 	
  // Advance to simulation time 4, check results, prepare next values
  #1 Clk = '0;
  $fdisplay(fd, "Checking that nothing happens before Start");
  assert (NextInstructionIndex == 'd1);
  Start = '1;
  write2file;

  // Advance to simulation time 5, latch values
  #1 Clk = '1;

  // Advance to simulation time 6, check results, prepare next values
  #1 Clk = '0;
  $fdisplay(fd, "Checking that nothing happened during Start");
  assert (NextInstructionIndex == 'd2);
  Start = '0;
  write2file;

  // Advance to simulation time 7, latch values
  #1 Clk = '1;

  // Advance to simulation time 8, check outputs, prepare next values
  #1 Clk = '0;
  $fdisplay(fd, "Checking that first Start went to first program");
  assert (NextInstructionIndex == 'd3);
  // No change in inputs
  write2file;	

  // Advance to simulation time 9, latch values
  #1 Clk = '1;

  // Advance to simulation time 10, check outputs, prepare next values
  #1 Clk = '0;
  $fdisplay(fd, "Checking that no branch advanced by 1");
  assert (NextInstructionIndex == 'd4);
  Branch = '1;
  TargetOrOffset = 'd10;
  write2file;

  // Latch, check, setup next test
  #1 Clk = '1;
  #1 Clk = '0;
 	
  $fdisplay(fd, "Checking that relative branch");
  assert (NextInstructionIndex == 'd14);
  Branch = '0;
  TargetOrOffset = 'd5;
  write2file;

  // Latch, check, setup next test
  #1 Clk = '1;
  #1 Clk = '0;
  $fdisplay(fd, "Checking no branching");
  assert (NextInstructionIndex == 'd15);
  write2file;

  $fdisplay(fd, "All checks passed.");
  // close file
  #10 $fclose(fd);
end

task write2file;
  $fdisplay(fd, "%t ClockCounter = %d, Branch = %b, TargetOrOffset = %d, NextInstructionIndex = %d", $time, ClockCounter, Branch, TargetOrOffset, NextInstructionIndex);
endtask

initial begin
  $dumpfile("ProgCtr.vcd");
  $dumpvars();
  $dumplimit(104857600); // 2**20*100 = 100 MB, plenty.
end

endmodule
