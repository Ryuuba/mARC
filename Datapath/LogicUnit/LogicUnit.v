module LogicUnit(a, b, opcode, y);

   parameter width = 16;
   
   input[width-1:0] a, b;
   input[1:0] opcode;
   output[width-1:0] y;

   wire[width-1:0] a, b;
   reg[width-1:0] y;
   wire[1:0] opcode;

   always @(*)
   begin
      case (opcode)
         2'b00:   y = a&b;
         2'b01:   y = a|b;
         2'b10:   y = ~a;
         default: y = a^b;
      endcase
   end

endmodule
