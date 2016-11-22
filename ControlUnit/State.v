module State(
  d, //each of the inputs of the FFD integrating the memory of the M machine
  q, //each of the outputs of the FFD
  clk, //clock signal
  preset //Signal that reset the control unit to the IF state
);

  input  wire[12:0] d; //next state logic
  input  wire       clk, preset; //Obvious, isn't it?
  output reg[12:0]  q; //current state

  always @(posedge clk) begin
      q <= d;
  end
  
  always @(preset) begin 
    if (preset) begin
        q <= 13'b0000000000001;
     end
  end 

endmodule // State
