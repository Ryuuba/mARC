`ifndef SIMPLE_FU_V
`define SIMPLE_FU_V

module FunctionalUnit(
  a, //main operand to perform microoperations
  b, //supporting operand
  opcode, //operational code for microoperations
  result, //a result
  status //flags CVZN
);

  input wire[15:0] a, b;
  input wire[3:0] opcode;
  output reg[15:0] result;
  output reg[3:0] status;

  reg[16:0] carry; //Internal reg keeping all generated carries
  integer i;

  //Computes result
  always @(*) begin
    casex (opcode)
      4'b0000: result = a & b;
      4'b0001: result = a | b;
      4'b0010: result = ~a;
      4'b0011: result = a ^ b;
      4'b0100: result = a + b + opcode[0];
      4'b0101: result = a + ~b + opcode[0];
      4'b10xx: result = a[7:0] * b[7:0];
      4'b1100: result = a << b[3:0];
      4'b1101: result = a >> b[3:0];
      4'b1110: result = a <<< b[3:0];
      default: result = a >>> b[3:0];  
    endcase
  end

  //Computes flags
  //Note that this code is not sinthetizable
  //TODO: Compute carries hierarchically 
  always @(*) begin
    carry[0]  = opcode[0];
    status[0] = result[15];
    status[1] = ~|result;
    for (i = 0; i < 16 ; i = i + 1) begin
      carry[i+1] = a[i]&b[i] | (a[i]^b[i]) & carry[i];
    end
    status[2] = carry[16];
    status[3] = carry[16] ^ carry[15];
  end

endmodule // FunctionalUnit

`endif