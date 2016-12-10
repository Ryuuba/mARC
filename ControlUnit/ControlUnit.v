//`include "NextStateLogic.v"
//`include "State.v"
//`include "OutputLogic.v"
`include "ControlUnit/NextStateLogic.v"
`include "ControlUnit/State.v"
`include "ControlUnit/OutputLogic.v"

module ControlUnit(
  clk,         //clock signal
  reset,       //signal resetting the control unit to the IF state
  instruction, //an instruction from the IR register
  status,      //processor status
  ctrlword,    //control word to manage the datapath
  rw_mem       //signal that indicates the operation mode of the main memory
);

  //Port definition
  input  wire       clk, reset;
  input  wire[4:0]  status; //d, v, c, z, n
  input  wire[15:0] instruction;
  output wire[19:0] ctrlword;
  output wire       rw_mem;

  //Internal signals
  wire[12:0] state, nextstate;

  NextStateLogic nsl_unit(
    instruction[15],    //instruction format
    instruction[14:11], //functional operation
    state,              //memory
    nextstate           //output of the nsl module
  );

  State state_unit(
    nextstate, //the input of the memory
    state,     //the output of the memory
    clk,       //the clock signal
    reset      //the reset signal
  );

  OutputLogic ol_unit(
    state,       //output memory
    status,      //output from the PSR register
    instruction, //an instruction from the IR register
    ctrlword,    //the control word generated by the control unit
    rw_mem
  );

endmodule // ControUnit
