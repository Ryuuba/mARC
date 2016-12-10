`include "Processor.v"
`timescale 1ns/100ps

module testbench;

  //outputs
  wire[15:0] busA, busB;
  wire rw;
  //inputs
  reg[15:0] dataIn;
  reg reset, clk;
  integer pc;
  
  Processor mARC(//marcee
    dataIn, //data or instructions comming from the main memory
    busA,   //Data comming from the bus A of the datapath
    busB,   //Data comming from the bus B of the datapath
    rw,     //signal indicating whether the main memory is to be written or not
    reset,  //signal reseting the processor
    clk    //clock signal
  );
  
  always #1 clk = ~clk;
  
  initial begin
    $dumpfile("marcee.vcd");
    $dumpvars(0, testbench);
    pc = 0;
    clk = 1;
    reset = 1;
    dataIn = 16'b0_1010_001_00001111; //setlow 15, %r1
    #10;
    reset = 0;
    dataIn = 16'b0_1010_010_00000011; //setlow 3, %r2
    #10;
    dataIn = 16'b0_1001_001_00000110; //ba 6 !%pc <-- %pc + 6
    #10;
    pc = busA;
    while(pc != 14) begin
      if (pc == 6) begin
        dataIn = 16'b0_0100_100_001_0_0_100; //add %r1, %r4, %r4 !acc <-- acc + r1
        #10;
        dataIn = 16'b0_0100_011_011_1_0001; //add %r3, 1, %r3
        #10;
      end
      dataIn = 16'b0_0101_000_011_0_1_010; //subcc %r3, %r2, %r0
      #10;
      dataIn = 16'b0_1001_111_11111010; //bl -6
      #10;
      pc = busA;
    end
    dataIn = 16'b0_1011_110_00001000; //sethi 8, %r6 !%r6 <-- 2048
    #10;
    dataIn = 16'b0_0111_100_110_0_0000; //st %r4, %r6
    #10 $finish;
  end
endmodule //testbench
