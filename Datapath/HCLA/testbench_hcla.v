`include "hcla.v"
`timescale 1ns/100ps

module testbench;
  localparam w = 16; 
  reg[w-1:0]  a, b;
  reg cin;
  wire[w-1:0] sum;
  wire c15, G, P;

  hierarchical_cla adder16b_u(a, b, cin, sum, c15, G, P);

  initial
  begin
    $dumpfile("hcla.vcd");
    $dumpvars(0, testbench);
    a = 16'h00A0; b = 16'h00A0; cin = 1'b0; //Addition
    #1;  
    a = 16'h00A0; b = ~a; cin = 1'b1; //Addition
    #1; 
    $finish;
  end

endmodule
