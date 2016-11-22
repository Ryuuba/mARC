`include "Reversal.v"
`timescale 1ns/100ps

module testbench;
   
   localparam w = 16;

   reg[w-1:0] a;
   reg sel;
   wire[w-1:0] y;

   defparam reversal_module.width = w;
   Reversal reversal_module(a, sel, y);

   initial
   begin
      $dumpfile("reversal.vcd");
      $dumpvars(0, testbench);
      a = 16'h0F0F;
      sel = 1'b0;
      #1;
      sel = ~sel;
      #1;
      $finish;
   end

endmodule
