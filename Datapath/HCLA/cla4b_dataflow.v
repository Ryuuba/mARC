module cla_adder(a, b, c_in, c_out, sum);
  
  parameter width = 4;
  
  input [width-1:0] a, b;
  input c_in;
  output [width-1:0] sum;
  output c_out;
  
  wire [width:0] c_int;
  wire [width-1:0] a, b, sum;
  wire c_in, c_out, G, P;
  assign c_int[0] = c_in;
  genvar i;
  generate
    for (i = 0; i < width; i = i + 1)
    begin
      assign c_int[i+1] =  (a[i] & b[i]) | ((a[i] | b[i]) & c_int[i]);
      assign sum[i] = a[i] ^ b[i] ^ c_int[i];
    end
  endgenerate
  assign c_out = c_int[width];
endmodule

