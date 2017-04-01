`ifndef PROCESSOR_V
`define PROCESSOR_V

`include "Datapath/Datapath.v"
`include "ControlUnit/ControlUnit.v"

module Processor(
  dataIn, //data or instructions comming from the main memory
  busA,   //Data comming from the bus A of the datapath
  busB,   //Data comming from the bus B of the datapath
  rw,     //signal indicating whether the main memory is to be written or not
  reset,  //signal reseting the processor
  clk     //clock signal
);

  input wire[15:0] dataIn;
  input wire clk, reset;
  output wire[15:0] busA, busB;
  output wire rw;
  
  //Internal signals
  wire[19:0] ctrlword;
  wire[15:0] instruction;
  wire[4:0] status; //d v c n z
  
  Datapath datapath_unit(
    clk,
    reset,
    ctrlword,
    instruction,
    status,
    dataIn,
    busA,
    busB
  );

  ControlUnit control_unit(
    clk,
    reset,
    instruction,
    status,
    ctrlword,
    rw
  );

endmodule //Processor

`endif
