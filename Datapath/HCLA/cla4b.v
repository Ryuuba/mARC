//Author: Adán G. Medrano-Chávez
//clc means carry lookahead cell
//cgl means carry generator logic
//cla means carry lookahead adder
`ifndef CLA4B_V
`define CLA4B_V

`include "Datapath/HCLA/clc.v"
`include "Datapath/HCLA/cgl4b.v"

module cla4b(a, b, cin, sum, G, P);
  localparam w = 4; //width
   
  input[w-1:0] a, b;
  input cin;
  output[w-1:0] sum;
  output G, P;
  
  wire[w-1:0] a, b, sum, g, p;
  wire[w-1:1] carry;
  wire cin, cout, G, P;


  cgl4b cgl_u(cin, g, p, carry, G, P);

  genvar i;
  generate
    for (i = 0; i < w; i=i+1)
    begin
      if (i == 0)
        clc adder_u(a[i], b[i], cin, sum[i], g[i], p[i]);
      else
        clc adder_u(a[i], b[i], carry[i], sum[i], g[i], p[i]);
    end
  endgenerate
  
  
endmodule

`endif
