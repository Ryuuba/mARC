`ifndef REVERSAL_V
`define REVERSAL_V
`include "Datapath/Basic/Mux2x1p.v"

module Reversal(a, sel, y);

   parameter width = 8;

   input[width-1:0] a;
   input sel;
   output[width-1:0] y;

   wire[width-1:0] a, y;
   wire sel;

   genvar i;
   generate
      for (i=0; i<width; i=i+1)
         Mux2x1 reversal_mux(a[i], a[width-i-1], sel, y[i]);
   endgenerate

endmodule

`endif
