`include "RightShifterRotator.v"
`timescale 1ns/100ps

module testbench;

   localparam w = 16;
   localparam v = $clog2(w);
   
   reg[w-1:0] a;
   reg[v-1:0] op1;
   reg op2;
   wire[w-1:0] y;

   defparam rsr.width = w;
   RightShifterRotator rsr(a, op1, op2, y);

   always
   begin
      #1 op1 = op1 + 1;
   end
   
   always
   begin
      #16 op2 = ~op2;
   end
   
   initial
   begin
      $dumpfile("rsr.vcd");
      $dumpvars(0, testbench);
      a = 16'hF0F0;
      op1 = 4'h0;
      op2 = 1'b0;
      #32 $finish;
   end

endmodule
