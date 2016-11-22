//Author: Adán G. Medrano-Chávez
//cgl means carry generator logic
//G and P are the generating and propagating functions
//of the module, respectively
//g and p are the generating and propagating functions
//coming from the carry lookahead cells, respectively
`ifndef CGL4B_V
`define CGL4B_V

module cgl4b(cin, g, p, carry, G, P);

   input[3:0] g, p;
   input cin;
   output[3:1] carry;
   output G, P;

   wire[3:0] g, p;
   wire[3:1] carry;
   wire cin, G, P;
  

   //dataflow 
   assign carry[1] = g[0] | (p[0] & cin);
   assign carry[2] = g[1] | (p[1]&g[0]) | (p[1]&p[0]&cin);
   assign carry[3] = g[2] | (p[2]&g[1]) | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0] & cin);
   assign G = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | 
              (p[3]&p[2]&p[1]&g[0]);
   assign P = p[3] & p[2] & p[1] & p[0];

endmodule

`endif
