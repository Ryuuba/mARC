`ifndef DECODER_V
`define DECODER_V

module Decoder(
  a, //addres input
  d  //Output
);

    parameter a_width = 2;
    localparam d_width = $pow(2, a_width);
    input wire[a_width-1 : 0] a;
    output wire[d_width-1:0] d;

    assign d = 1 << a;

endmodule // Decoder

`endif