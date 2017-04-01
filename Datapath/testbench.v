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
    initial begin
      $dumpfile("datapath.vcd");
      $dumpvars(0, testbench);
      //Fill the file register
      clk = 0;
      #1;
      for (i = 0; i < 16; i = i + 1) begin
        dataIn = 2**i;
        ctrlword = {i[3:0],i[3:0],i[3:0],1'b1,1'b1,1'b0,1'b0,4'b0};
        #2;
      end
      //Test the operations of the functional unit except sign ext and incpc
      for (i = 0; i < 14; i = i + 1) begin
        ctrlword = {i[3:0],i[3:0],i[3:0],1'b1,1'b0,1'b0,1'b0,i[3:0]};
        #2;
      end
      //Test sign extension
      dataIn = 16'b0_0100_011_001_1_1000;//add %r1, -8, %r3
      ctrlword = 20'b0000_0000_1111_1_1_0_0_0000;
      #2;
      ctrlword = 20'b1111_0000_1101_1_0_0_0_1110;
      //Test incpc
      ctrlword = 20'b1110_0000_1110_1_0_0_0_1111;
      #2 $finish;
    end

endmodule // testbench; 
