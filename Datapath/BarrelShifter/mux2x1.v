`ifndef MUX2X1_V
`define MUX2X1_V

module mux2x1(a, b, sel, y);
   
   parameter width = 1;

   input[width-1:0] a, b;
   input sel;
   output[width-1:0] y;

   wire[width-1:0] a, b;
   reg[width-1:0] y;
   wire sel;

   always @(*)
   begin
      if (sel == 1'b0)
         y = a;
      else
         y = b;
   end

endmodule

`endif
