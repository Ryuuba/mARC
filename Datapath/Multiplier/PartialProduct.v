`ifndef PARTIAL_PRODUCT_V
`define PARTIAL_PRODUCT_V

module PartialProduct(a, b, m, q, cout, sum);
  input a, b, m, q;
  output cout, sum;
  //By default, all ports are wires
  //Dataflow design
  assign sum = a ^ b ^ (m & q);
  assign cout = (a & b) | (a & m & q) | (b & m & q);
endmodule

`endif
