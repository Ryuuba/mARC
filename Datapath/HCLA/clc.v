//Author: Adán G. Medrano-Chávez
//clc means carry lookahead cell
//g is the function generating the output carry
//p is the function propagating the input carry
`ifndef CLC_V
`define CLC_V

module clc(a, b, cin, sum, g, p);

   input a, b, cin;
   output sum, g, p;

   wire a, b, cin, sum, g, p;

   assign g = a & b;
   assign p = a ^ b;
   assign sum = p ^ cin;

endmodule

`endif
