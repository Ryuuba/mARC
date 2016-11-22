`include "right_shifter.v"
`timescale 1ns/100ps

module testbench;
   
   localparam w = 16;
   localparam l = $clog2(w);
   
   reg[w-1:0] a;
   reg[l-1:0] b;
   wire[w-1:0] y;

   defparam rs_u.width = w;
   right_shifter rs_u(a, b, y);

   initial
   begin
      $dumpfile("right_shifter.vcd");
      $dumpvars(0, testbench);
      a = 16'hFFFF;
      b = 4'h0;
      #1;
      a = 16'hFFFF;
      b = 4'h1;
      #1;
      a = 16'hFFFF;
      b = 4'h2;
      #1;
      a = 16'hFFFF;
      b = 4'h3;
      #1;
      a = 16'hFFFF;
      b = 4'h4;
      #1;
      a = 16'hFFFF;
      b = 4'h5;
      #1;
      a = 16'hFFFF;
      b = 4'h6;
      #1;
      a = 16'hFFFF;
      b = 4'h7;
      #1;
      a = 16'hFFFF;
      b = 4'h8;
      #1;
      a = 16'hFFFF;
      b = 4'h9;
      #1;
      a = 16'hFFFF;
      b = 4'hA;
      #1;
      a = 16'hFFFF;
      b = 4'hB;
      #1;
      a = 16'hFFFF;
      b = 4'hC;
      #1;
      a = 16'hFFFF;
      b = 4'hD;
      #1;
      a = 16'hFFFF;
      b = 4'hE;
      #1;
      a = 16'hFFFF;
      b = 4'hF;
      #1;
      $finish;
   end

endmodule
