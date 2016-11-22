`include "BarrelShifter.v"
`timescale 1ns/100ps

module testbench;

   localparam w = 16;
   localparam v = $clog2(w);
   
   reg[w-1:0] a;
   reg[v-1:0] op1;
   reg[1:0] op2;
   wire[w-1:0] y;

   defparam bs.width = w;
   BarrelShifter bs(a, op1, op2, y);

   always
   begin
      #1 op1 = op1 + 1;
   end
   
   always
   begin
      #16 op2 = op2+1;
   end
   
   initial
   begin
      $dumpfile("bs.vcd");
      $dumpvars(0, testbench);
      a = 16'hF0F0;
      op1 = 4'h0;
      op2 = 2'b00;
      #64 $finish;
   end

endmodule
