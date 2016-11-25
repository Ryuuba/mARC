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
    
    reg[15:0] aux;
    reg[15:0] dest;

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
      ctrlword = 20'b0000001001000000000000;//ID
      reset = 1;
      clk = 0;
      dataIn = 2; //setlow 64, %r1
      #1;
      for (i = 0; i < 16; i = i + 1) begin
        aux = i;
        ctrlword = {ctrlword[21:21],aux,crtlword[7:0]};
        dataIn = dataIn**i;
        #2;
      end
      aux = 0;
      for (i = 0; i < 16; i = i + 1) begin
        dest = i;
        aux = i;
        ctrlword = {crtlword[21:20],aux,crtlword[15:12],dest,aux,aux};
        dataIn = dataIn**i;
        #2;
      end      
      #2 $finish;
    end

endmodule // testbench; 
