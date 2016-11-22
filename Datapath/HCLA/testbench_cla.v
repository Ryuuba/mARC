`include "cla_adder.v"
`timescale 1ns/100ps

module testbench;
  parameter w = 4;
  wire [w-1:0] sum;
  wire c_out;
  reg [w-1:0] a, b;
  cla_adder #(.width(w)) cla_u(a, b, 1'b0, c_out, sum);
  initial
  begin
    $dumpfile("cla_adder.vcd");
    $dumpvars(0, testbench);
    a = 4'b0000; b = 4'b0000;
    #1;
    a = 4'b0001; b = 4'b0100;
    #1;
    a = 4'b0010; b = 4'b0000;
    #1;
    a = 4'b0011; b = 4'b0100;
    #1;
    a = 4'b0100; b = 4'b0110;
    #1;
    a = 4'b0111; b = 4'b1101;
    #1;
    a = 4'b1101; b = 4'b1000;
    #1;
    $finish;
  end
endmodule
