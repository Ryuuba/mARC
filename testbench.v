`include "Processor.v"
`timescale 1ns/100ps

module testbench;

  //outputs
  wire[15:0] busA, busB;
  wire rw;
  //inputs
  reg[15:0] dataIn;
  reg reset, clk;
  
  
  Processor mARC(//marcee
    dataIn, //data or instructions comming from the main memory
    busA,   //Data comming from the bus A of the datapath
    busB,   //Data comming from the bus B of the datapath
    rw,     //signal indicating whether the main memory is to be written or not
    reset,  //signal reseting the processor
    clk    //clock signal
  );
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    $dumpfile("marcee.vcd");
    $dumpvars(0, testbench);
    clk = 0;
    reset = 1;
    dataIn = 16'b0101000101000000; //setlow 64, %r1
    #0.5;
    reset = 0;
    #8;
    dataIn = 16'b0101101000000001; //sethi 1, %r2
    #10 $finish;
  end
  
endmodule //testbench
