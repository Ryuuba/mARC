`include "Multiplier.v"
`timescale 1ns/100ps

module testbench;
  parameter w = 8;
  reg [w-1:0] m, q;
  wire [w*2-1:0] mult;
  wire cout;
  Multiplier #(.width(w)) u_mult(m, q, mult);
  initial
  begin
    $dumpfile("multiplier.vcd");
    $dumpvars(0, testbench);
    m = 8'b1111; q = 8'b0000;
    #1;
    m = 8'b1111; q = 8'b1101;
    #1;
    m = 8'b1101; q = 8'b1010;
    #1;
    m = 8'hFF; q = 8'hFF;
    #1;
    m = 8'hF0; q = 8'h00; 
    #1; 
    m = 8'hA0; q = 8'hFF; 
    #1; 
    m = 8'hAA; q = 8'hFF; 
    #1; 
    m = 8'h05; q = 8'h06;
    #1;
    $finish;
  end
endmodule
