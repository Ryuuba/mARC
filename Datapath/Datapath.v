`ifndef DATAPATH_V
`define DATAPATH_V

`include "Datapath/SimpleFunctionalUnit/FunctionalUnit.v"
//`include "Datapath/FunctionalUnit/FunctionalUnit.v"
`include "Datapath/FileRegister/FileRegister.v"
`include "Datapath/Basic/Mux2x1p.v"
`include "Datapath/PSR/ProcessorStatusRegister.v"

//The first line in the port module is the control word determining
//the datapath behavior
//The second line is the clock signal
//The last line is the output of the datapath, status contains the
//the flags VCNZ, the bus A conveys the data address to the 
//main memory and busB contains the data to be stored

module Datapath(
  clk,
  reset,
  ctrlword,
  instruction,
  status,
  dataIn,
  busA,
  busB
);

    input wire clk, reset;
    input wire[19:0] ctrlword;
    input wire[15:0] dataIn;
    
    output wire[15:0] instruction, busA, busB;
    output wire[4:0] status;//D V C N Z flags
    
    /*Internal signals*/
    wire[15:0] result; //Result of the Functional Unit
    wire[15:0] dataBus; //Output of the MUX D
    wire[3:0] flags; //The status of an operation (V C N Z)

    //FileRegister(clk, addrA, addrB, addrD, rw, data, busA, busB);
    FileRegister file_register_u(
        clk,             //clock signal
        reset,           //reset signal
        ctrlword[19:16], //addrA
        ctrlword[15:12], //addrB
        ctrlword[11:8],  //addrD
        ctrlword[7],     //~read signal
        dataBus,         //data bus
        busA,            //address bus
        busB,            //output data bus
        instruction      //the content of the IR register
    );

    //FunctionalUnit(a, b, opcode, y, status)
    FunctionalUnit functional_u(
        busA,          //Operand A from file register
        busB,          //output data bus
        ctrlword[3:0], //opcode
        result,        //Result from the funtional unit
        flags          //The status of an operation
    );
    
    //ProcessorStatusRegister(clk, reset, rw, displacement, flags, status)
    ProcessorStatusRegister psr_u(
        clk,         //clk signal
        reset,       //reset signal
        ctrlword[5], //PSR_rw signal
        ctrlword[4], //the set-displacement signal
        flags,       //status of an operation
        status       //the content of the PSR register
    );

    //module Mux2x1(a, b, sel, y);
    defparam muxd.width = 16;
    Mux2x1 muxd(
        result,      //Result from the functional unit
        dataIn,      //Data from the main memory
        ctrlword[6], //Data selection signal
        dataBus      //Input of the file register
    );

endmodule //module Datapath

`endif
