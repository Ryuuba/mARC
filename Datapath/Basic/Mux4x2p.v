`ifndef MUX4X2P_V
`define MUX4X2P_V

module Mux4x2(a, b, c, d, sel, y);

   parameter width = 1;
   
   input[width-1:0] a, b, c, d;
   input[1:0] sel;
   output[width-1:0] y;

   wire[width-1:0] a, b, c, d;
   wire[1:0] sel;
   reg[width-1:0] y;

   always @ (*)
   begin
      if (sel == 2'b00)
         y = a;
      else if (sel == 2'b01)
         y = b;
      else if (sel == 2'b10)
         y = c;
      else
         y = d;
   end

endmodule

`endif
