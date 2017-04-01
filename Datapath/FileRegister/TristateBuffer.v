`ifndef TRISTATE_BUFFER_V
`define TRISTATE_BUFFER_V

module TristateBuffer(
  data_in,
  data_out,
  enable
);

  parameter data_width = 1;
  input wire[data_width-1:0] data_in;
  input wire enable;
  output wire[data_width-1:0] data_out;

  generate
    genvar i;
    for (i = 0; i < data_width; i = i + 1)
      assign data_out[i] = (enable) ? data_in[i] : 1'bz;
  endgenerate

endmodule // TristateBuffer

`endif