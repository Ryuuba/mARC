`include "FunctionalUnit.v"
`timescale 1ns/100ps

module testbench;

  wire[15:0] result;
  wire[3:0] status;
  reg[15:0] a, b;
  reg[3:0] opcode;

  FunctionalUnit fu(a, b, opcode, result, status);

  always begin
    #1 opcode = opcode + 1;
  end

  initial begin
    $dumpfile("functional_unit.vcd");
    $dumpvars(0, testbench);
    a = 16'h00FF;
    b = 16'h0007;
    opcode = 0;
    #17 $finish;
  end

endmodule // testbench