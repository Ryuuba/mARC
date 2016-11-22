`ifndef MUX16X4_V
`define MUX16X4_V

module Mux16x4(a0, a1, a2, a3, a4, a5, a6, a7,
               a8, a9, a10, a11, a12, a13, a14, a15,
               sel, y);
   
   parameter width = 1;
   
   input[width-1:0] a0, a1, a2, a3, a4, a5, a6, a7,
                    a8, a9, a10, a11, a12, a13, a14, a15;
   input[2:0] sel;
   output[width-1:0] y;

   wire[width-1:0] a0, a1, a2, a3, a4, a5, a6, a7,
                   a8, a9, a10, a11, a12, a13, a14, a15;
   wire[2:0] sel;
   reg[width-1:0] y;

   always @ (*)
   begin
      if (sel == 4'b0000)
         y = a0;
      else if (sel == 4'b0001)
         y = a1;
      else if (sel == 4'b0010)
         y = a2;
      else if (sel == 4'b0011)
         y = a3;
      else if (sel == 4'b0100)
         y = a4;
      else if (sel == 4'b0101)
         y = a5;
      else if (sel == 4'b0110)
         y = a6;
      else if (sel == 4'b0111)
         y = a7;
      else if (sel == 4'b1000)
         y = a8;
      else if (sel == 4'b001)
         y = a9;
      else if (sel == 4'b1010)
         y = a10;
      else if (sel == 4'b1011)
         y = a11;
      else if (sel == 4'b1100)
         y = a12;
      else if (sel == 4'b1101)
         y = a13;
      else if (sel == 4'b1110)
         y = a14;
      else
         y = a15;
   end
endmodule

`endif