`include "Demux.v"
`timescale 1ns/100ps

module Testbench;
    reg in;
    reg[1:0] sel;
    wire[3:0] f;

    integer i;

    defparam demux2x4.sel_width = 2;
    Demux demux2x4(in, sel, f);

    initial begin
      $dumpfile("demux.vcd");
      $dumpvars(0, Testbench);
      in = 1;
      for (i = 0; i < 4; i = i + 1) begin
        sel = i;
        #1;
      end
      $finish;
    end
endmodule