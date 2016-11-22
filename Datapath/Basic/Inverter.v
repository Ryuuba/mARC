`ifndef INVERTER_V
`define INVERTER_V

module Inverter(a, sel, y);

   parameter width = 1;

   input[width-1:0] a;
   input sel;
   output[width-1:0] y;

   wire[width-1:0] a, y;
   wire sel;

   genvar i;
   generate
      for (i = 0; i < width; i = i+1)
         assign y[i] = a[i] ^ sel;
   endgenerate

endmodule

`endif
