`ifndef RIGHT_SHIFTER_V
`define RIGHT_SHIFTER_V

`include "mux2x1.v"

module right_shifter(a, b, y);
   
   //parameters to customize the right shifter rotator
   parameter width = 8;
   localparam level = $clog2(width);
   //ports
   input[width-1:0] a;
   input[level-1:0] b;
   output[width-1:0] y;
   
   //internals wires used to connect muxes
   wire[width-1:0] mux_out[level-2:0];
   //This circuit is combinational, so ports are wires
   wire[width-1:0] a, y;
   wire[level-1:0] b;

   genvar i, j;
   generate
      for (i = 0; i < level; i=i+1)
         for (j = 0; j < width; j=j+1)
            case (i)
               0:
                  if(j < width - 2**i)
                     mux2x1 mux_u(mux_out[i][j], mux_out[i][2**i+j], b[i], y[j]);
                  else
                     mux2x1 mux_u(mux_out[i][j], 1'b0, b[i], y[j]);
               level-1:
                  if(j < width - 2**i)
                     mux2x1 mux_u(a[j], a[2**i+j], b[i], mux_out[i-1][j]);
                  else
                     mux2x1 mux_u(a[j], 1'b0, b[i], mux_out[i-1][j]);
               default:
                  if(j < width - 2**i)
                     mux2x1 mux_u(mux_out[i][j], mux_out[i][2**i+j], b[i], mux_out[i-1][j]);
                  else
                     mux2x1 mux_u(mux_out[i][j], 1'b0, b[i], mux_out[i-1][j]);
            endcase
   endgenerate
endmodule

`endif
