`include "Datapath.v"
`timescale 1ns/100ps

module testbench;
    localparam w = 16;
    reg clk, reset;
    reg[19:0] ctrlword;
    reg[15:0] dataIn;

    wire[4:0] status;
    wire[15:0] busA, busB, instruction;

    integer i; //iterator

    always
    begin
      #1 clk = ~clk;
    end

    Datapath datapath(
      clk,
      reset,
      ctrlword,
      instruction,
      status,
      dataIn,
      busA,
      busB
    );

    //Testing the register file
    initial
    begin
      $dumpfile("datapath.vcd");
      $dumpvars(0, testbench);
      ctrlword = 20'b00000000000000000000;//ID
      reset = 1;
      clk = 0;
      dataIn = 16'b0101000101000000; //setlow 64, %r1
      #1.5;
      reset = 0;
      ctrlword = 20'b11100000111111000000;//IF
      #2;
      ctrlword = 20'b00000000000000000000;//ID
      #2;
      ctrlword = 20'b11111001110110000000;//OF setlow
      #2;
      ctrlword = 20'b11011101000110000000;//EI
      #2;
      ctrlword = 20'b11101100111010000100;//IP
      dataIn = 16'b0101101000000001; //sethi 1, %r2
      #2;
      ctrlword = 20'b11100000111111000000;//IF
      #2;
      ctrlword = 20'b00000000000000000000;//DO
      #2;
      ctrlword = 20'b10101011110110000000;//OF sethi
      #2;
      ctrlword = 20'b11111101001010001101;//EW sethi
      #2;
      ctrlword = 20'b11101100111010000100;//IP
      dataIn = 16'b0000000000000000; //nop
      #2;
      ctrlword = 20'b11100000111111000000;//IF
      #2 $finish;
    end

endmodule // testbench; 
