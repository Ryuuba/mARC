`ifndef FILE_REGISTER_V
`define FILE_REGISTER_V

`ifdef PROCESSOR_V
  `include "Datapath/FileRegister/Decoder.v"
  `include "Datapath/FileRegister/Demux.v"
  `include "Datapath/FileRegister/Register.v"
  `include "Datapath/FileRegister/TristateBuffer.v"
`elsif DATAPATH_V
  `include "FileRegister/Decoder.v"
  `include "FileRegister/Demux.v"
  `include "FileRegister/Register.v"
  `include "FileRegister/TristateBuffer.v"
`else
  `include "Decoder.v"
  `include "Demux.v"
  `include "Register.v"
  `include "TristateBuffer.v"
`endif

module FileRegister(
  data_bus, //Data input
  bus_a,
  bus_b,
  bus_ir,
  addr_a,
  addr_b,
  addr_d,
  reset,
  rw,
  clk
);

  localparam data_width = 16;
  localparam addr_width = $clog2(data_width);
  input wire[data_width-1:0] data_bus;
  input wire[addr_width-1:0] addr_a, addr_b, addr_d;
  input wire rw, reset, clk;
  output wire[data_width-1:0] bus_a, bus_b, bus_ir;

  //Internal wires
  //d is an array of buses connecting the output of the tristate buffers to
  //the input of each register.
  wire[data_width-1:0] d[data_width-1:0], q[data_width-1:0];
  wire[data_width-1:0] enable_a, enable_b, enable_d, write_reg;


  defparam dec_d.a_width = addr_width;
  Decoder dec_d(addr_d, enable_d);
  defparam dec_a.a_width = addr_width;
  Decoder dec_a(addr_a, enable_a);
  defparam dec_b.a_width = addr_width;
  Decoder dec_b(addr_b, enable_b);

  defparam demux.sel_width = addr_width;
  Demux demux(rw, addr_d, write_reg);

  generate
    genvar i;
    for (i = 0; i < data_width; i = i + 1) begin
      defparam buffer_d.data_width = data_width;
      TristateBuffer buffer_d(data_bus, d[i], enable_d[i]);

      defparam buffer_a.data_width = data_width;
      TristateBuffer buffer_a(q[i], bus_a, enable_a[i]);

      defparam buffer_b.data_width = data_width;
      TristateBuffer buffer_b(q[i], bus_b, enable_b[i]);

      if (i != 0 && i != 9 && i != 10 && i != 11 && i != 12) begin
        defparam register.data_width = data_width;
        Register register(d[i], q[i], reset, write_reg[i], clk);
      end
    end
  endgenerate
  //TODO: eliminate these constants
  assign q[0]   = 16'h0000;
  assign q[9]   = 16'h00FF;
  assign q[10]  = 16'h000F;
  assign q[11]  = 16'hFFF8;
  assign q[12]  = 16'h0002;
  assign bus_ir = q[15];

endmodule //FileRegister

`endif