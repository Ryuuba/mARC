// Author: Adan G. Medrano-Chavez
// Program: right shifter rotator
// This module is a logical module made with 2x1 muxes. Its inputs are
// an n-bit vector named a and an opcode integrated by log2(n)+2 bits. Its
// output is an n-bit vector named y. This module carries out these 
// operations: shift logic right, shift arithmetic right, and rotate right.
// Operations are determined according to the the opcode. Specifically, the
// opcode is a pair <operation, num of movements>. The first element is a
// two bits code indicating the kind of operation the module performs. The
// following table describes the posible operations:
//        00 ---> do nothing
//        01 ---> shift right arithmetic
//        1X ---> rotate right
// The second element is simply the number of movements the module performs
// on the operand a.

`ifndef right_shifter_rotator_v
`define right_shifter_rotator_v

`include "mux2x1.v"

module rsr(a, opcode, y);
  parameter width = 4;
  localparam height = $clog2(width);
  localparam opcode_width = height+2;
  input[width-1:0] a;
  input[opcode_width-1:0] opcode;
  output[width-1:0] y;

  wire[width-1:0] a, y, shift[height:0];
  wire rotate[width-1:1];
  wire s;

  mux2x1 mux_arithmetic(1'b0, a[width-1], opcode[opcode_width-2], s);
  assign shift[height] = a;
  genvar i, j, k;
  generate
    for (i = 0; i < height; i=i+1)
    begin
      for (j = 0; j < width; j=j+1)
      begin
        if (j < width-2**i)
          mux2x1 mux_u(shift[i+1][j], shift[i+1][j+2**i], 
                       opcode[i], shift[i][j]);
        else
          mux2x1 mux_u(shift[i+1][j], rotate[2**(i+1)-width+j], 
                       opcode[i], shift[i][j]);
end
      for(k = 0; k < 2**i; k=k+1)
        mux2x1 mux_u(s, shift[i+1][k], opcode[opcode_width-1], rotate[2**i+k]);
    end
  endgenerate
  assign y = shift[0];
endmodule

`endif
