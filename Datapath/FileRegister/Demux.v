`ifndef DEMUX_V
`define DEMUX_V

module Demux(
  in, 
  sel,
  f
);

    parameter sel_width = 2;
    localparam f_width = $pow(2, sel_width);
    input wire in;
    input wire[sel_width-1:0] sel;
    output wire[f_width-1:0] f;

    generate
        genvar i;
        for (i = 0; i < f_width; i = i + 1) 
          assign f[i] = (sel == i) ? in : 0;
    endgenerate

endmodule // Demux

`endif