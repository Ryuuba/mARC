`include "ControlUnit.v"
`timescale 1ns/100ps

module testbench;

  reg clk, reset;
  reg[4:0] status;
  reg[15:0] instruction;

  wire[19:0] ctrlword;
  wire rw_mem, rw_psr, set_disp;

  ControlUnit control_unit(clk, reset, instruction, status, ctrlword, rw_mem);

  always begin
    #1 clk = ~clk;
  end

  initial begin
    $dumpfile("controlunit.vcd");
    $dumpvars(0, testbench);    
    clk = 1;
    status = 0;
    reset = 1;
    //instruction =  16'b0010111100000011; //subcc %r0, %r3, %r7
    instruction     =  16'b0010001100100010; //subcc %r0, %r3, %r7
    #10 instruction =  16'b0011011100000001; //ld [%r1+%r0], %r7
    #10 instruction =  16'b0011111100010001; //st [%r1-%r0], %r7
    #10 instruction =  16'b0100100000000111; //jmpl
    #10 instruction =  16'b0100100111111111; //ba
    #10 instruction =  16'b0101011111111111; //setlow FF, %r7
    #10 instruction =  16'b0101111111111111; //sethi FF, %r7
    #10 instruction =  16'b1111111111110000; //call
    #12 $finish;
  end

endmodule // testbech;
