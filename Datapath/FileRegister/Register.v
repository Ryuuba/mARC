`ifndef REGISTER_V
`define REGISTER_V
//Synchronous register
module Register(
  d,  //Data input
  q,  //State output
  reset,
  rw,
  clk
);

  parameter data_width = 4;

  input wire[data_width-1:0] d;
  input wire reset, rw, clk;
  output wire[data_width-1:0] q;

  reg[data_width-1:0] state;

  always @(negedge clk) begin
    if (reset) state <= 0;
    else if (rw) state <= d;
  end

  assign q = state;

endmodule // Register

`endif
