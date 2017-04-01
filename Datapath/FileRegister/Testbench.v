`include "FileRegister.v"
`timescale 1ns/100ps

module Testbench;

  reg clk, rw, reset;
  reg[15:0] data_bus;
  reg[3:0] addr_a, addr_b, addr_d;

  wire[15:0] bus_a, bus_b, bus_ir;

  integer i;

  FileRegister filereg(data_bus, bus_a, bus_b, bus_ir, addr_a, addr_b, addr_d, reset, rw, clk);

  always #1 clk = ~clk;

  initial begin
    $dumpfile("filereg.vcd");
    $dumpvars(0, Testbench);
    clk = 0;
    rw = 1;
    reset = 0;
    data_bus = 16'hFFDD;
    #0.5;
    for (i = 0; i < 16; i = i + 1) begin      
      addr_d = i;
      addr_a = i;
      addr_b = i;
      #2;
    end
    $finish;
  end

endmodule // Testbench