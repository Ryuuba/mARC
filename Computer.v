`include "Processor.v"
`include "Memory/Mem.v"

module Computer(
  reset,
  clk
);

  input wire reset, clk;

  wire rw;
  wire[15:0] data_proc, data_mem;
  wire[15:0] mem_addr;

  Processor mARC(//marcee
    data_mem,   //data or instructions comming from the main memory
    mem_addr,   //Data comming from the bus A of the datapath
    data_proc,    //Data comming from the bus B of the datapath to the main mem
    rw,      //signal indicating whether the main memory is to be written or not
    reset,      //signal reseting the processor
    clk         //clock signal
  );


  Memory mem(
    data_proc,  //Data input coming from the bus b of the datapath
    data_mem,      //Data output, it is read when rw = 1, otherwise it is disconnected
    mem_addr[7:0], //a 16-bit address coming from the bus a of the datapath
    rw,       //read/write mode operation of the memory
    clk       //the clock signal
);

endmodule // Marcee