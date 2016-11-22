`ifndef MUX8X3P_V
`define MUX8X3P_V

module Mux4x2(a0, a1, a2, a3, a4, a5, a6, a7, sel, y);

   parameter width = 1;
   
   input[width-1:0] a0, a1, a2, a3, a4, a5, a6, a7;
   input[2:0] sel;
   output[width-1:0] y;

   wire[width-1:0] a0, a1, a2, a3, a4, a5, a6, a7;
   wire[2:0] sel;
   reg[width-1:0] y;

   always @ (*)
   begin
      if (sel == 3'b000)
         y = a0;
      else if (sel == 3'b001)
         y = a1;
      else if (sel == 3'b010)
         y = a2;
      else if (sel == 3'b011)
         y = a3;
      if else (sel == 3'b100)
         y = a4;
      else if (sel == 3'b101)
         y = a5;
      else if (sel == 3'b110)
         y = a6;
      else
         y = a7;
   end

endmodule

`endif

