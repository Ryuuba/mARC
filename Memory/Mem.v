`ifndef MEMORY_V
`define MEMORY_V

module Memory(
  data_in,  //Data input coming from the bus b of the datapath
  data_out, //DAta output, it is read when rw = 1, otherwise it is disconnected
  addr,     //a 16-bit address coming from the bus a of the datapath
  rw,       //read/write mode operation of the memory
  clk       //the clock signal
);

  //Default parameters define a 256x16 memory
  parameter wordsize = 16; //the word size
  parameter addrsize = 8; //the log_2 of the address-space size
  localparam memdepth = $pow(2, addrsize); //the address space size
  integer it;

  //bus conveying the data to be wirtten
  input wire[wordsize-1:0] data_in;
  //bus conveying the operand addresses
  input wire[addrsize-1:0] addr;
  //buses conveying the rw permisson and the clock signal, respectively
  input wire rw, clk;
  //buses conveying the operands to be processed
  output wire[wordsize-1:0] data_out;

  wire[addrsize-1:0] word_addr;

  //memory storing the values to be processed
  reg[wordsize-1:0] memory[memdepth:0];

  //This initial block initializes the memory with the data stored in a program
  //Note that this kind of memory is only used to testbench a processor. It's 
  //recommendable you utilize the memory embebed in your FPGA board.
  initial begin
    //$readmemh(filename, mem_array, start_addr, stop_addr);
    //The last two value are optional arguments
    $readmemb("./Memory/max.bin", memory, 0, 255);//maximum program is loaded
  end

  assign word_addr = addr >> 1;

  always @(posedge clk) begin
    if (rw)
      memory[word_addr] <= data_in;
  end

  generate
  genvar i;
  for (i = 0; i < wordsize; i = i + 1)
    assign data_out[i] = (rw) ? 1'bz : memory[word_addr][i];
  endgenerate

endmodule // DataMemory

`endif
