//Author: Adán G. Medrano-Chávez
//cla means carry lookahead adder
//cgl means carry generator logic
`ifndef HCLA_V
`define HCLA_V
`include "Datapath/HCLA/cla4b.v"

module HierarchicalCLA(a, b, cin, sum, c15, G, P);
  
  localparam w = 16;//This parameter cannot be overwritten
  localparam leaf = $clog2(w);//This parameter cannot be overwritten
  
  input[w-1:0] a, b;
  input cin;
  output[w-1:0] sum;
  output c15, G, P;

  wire[w-1:0] a, b, sum;
  wire[leaf-1:0] g, p;
  wire[leaf-1:0] cgl_g, cgl_p;
  wire[leaf-1:1] carry;
  wire[leaf-2:1] cgl_carry;
  wire cin, c15, G, P;

  genvar i, j;
  generate
    for (i = 0; i < leaf; i = i+1)
    begin
      if(i == 0)
        cla4b adder_u(a[leaf*(i+1)-1:leaf*i],
                      b[leaf*(i+1)-1:leaf*i],
                      cin, 
                      sum[leaf*(i+1)-1:leaf*i],
                      g[i],
                      p[i]);
      else if (i == leaf-1)
      begin
         for (j=0; j < leaf; j = j+1)
         begin
            if (j == 0)
               clc clc_u(a[j+12],
                         b[j+12],
                         carry[i],
                         sum[j+12],
                         cgl_g[j],
                         cgl_p[j]);
            else if (j == leaf-1)
               clc clc_u(a[j+12],
                         b[j+12],
                         c15,
                         sum[j+12],
                         cgl_g[j],
                         cgl_p[j]);
            else
               clc clc_u(a[j+12],
                         b[j+12],
                         cgl_carry[j],
                         sum[j+12],
                         cgl_g[j],
                         cgl_p[j]);               
         end
         cgl4b cgl_u(carry[i], 
                     cgl_g,
                     cgl_p,
                     {c15,cgl_carry},
                     g[i],
                     p[i]);
      end
      else
        cla4b adder_u(a[leaf*(i+1)-1:leaf*i],
                      b[leaf*(i+1)-1:leaf*i],
                      carry[i], 
                      sum[leaf*(i+1)-1:leaf*i],
                      g[i],
                      p[i]);
    end
  endgenerate

  cgl4b carry_logic_u(cin, g, p, carry, G, P);

endmodule

`endif
