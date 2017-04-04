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
    $dumpfile("max.vcd");
    $dumpvars(0, testbench);
    clk = 0;
    reset = 0;
    dataIn = 16'b1_000001000000000; //call 1024 to initialize the PC register
    #0.5;
    reset = 1;
    #1;
    reset = 0;
    #9.5;
    dataIn = 16'b0101000101000000; //setlow 64, %r1
    #10;
    dataIn = 16'b0101101000000001; //sethi 1, %r2
    #10;
    dataIn = 16'b1111100000000010; //call 0xF004 (61444)
    #10;
    dataIn = 16'b0010100000101010; //subcc %r1, %r2, %r0
    #10;
    dataIn = 16'b0100110100000110; //ble 3 !%pc <-- %pc + 6
    #10;
    if (busA == 16'hF008) begin
      dataIn = 16'b0000101100100000; //mov %r1, %r3
      #10;
      dataIn = 16'b0100100100000100; //ba 2 !%pc <-- %pc + 4
      #10;
    end
    else begin
      dataIn = 16'b0000101101000000; //mov %r2, %r3
      #10;
    end
    dataIn = 16'b0100100000000111; //jmp %r7
    #10;
    dataIn = 16'b0101111000001000; //sethi 8, %r6 !%r6 <-- 2048
    #10;
    dataIn = 16'b0011101111000000; //st %r3, %r6
    #10 $finish;
  end
  
endmodule //testbench
