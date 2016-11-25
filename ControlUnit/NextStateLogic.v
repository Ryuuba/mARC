module NextStateLogic(
  opc1,     //operational code indicating the instruction format
  opc2,     //operational code indicating the functional operation 
  state,    //Memory of the Mealey machine
  nextstate //Output of the next-state-logic module
);

  input  wire[12:0] state;
  input  wire       opc1;
  input  wire[3:0]  opc2;
  output wire[12:0] nextstate;

  //Instruction fetch
  assign nextstate[0] = state[12];

  //Instruction decode
  assign nextstate[1] = state[0];

  //Operand fetch in microop
  assign nextstate[2] = state[1] & ~opc1 & (~(opc2[3] ^ opc2[2]) | //Logic and shift
                                   ~opc2[3] & opc2[2] & ~opc2[1] | //add
                                   ~opc2[1] & ~opc2[0] ); //mult
  //Instruction execution in microop
  assign nextstate[3] = state[2];

  //Operand fetch in memory instructions
  assign nextstate[4] = state[1] & ~opc1 & ~opc2[3] & opc2[2] & opc2[1];
  
  //Instruction execution in memory instructions
  assign nextstate[5] = state[4];

  //Operand fetch in jump instructions
  assign nextstate[6] = state[1] & ~opc1 & opc2[3] & ~opc2[2] & ~opc2[1] & opc2[0];

  //Instruction execution in jump instructions
  assign nextstate[7] = state[6];

  //Operand fetch in set-constant instructions
  assign nextstate[8] = state[1] & opc2[3] & ~opc2[2] & opc2[1];

  //Instruction execution in set-constant instructions
  assign nextstate[9] = state[8];

  //Link program counter
  assign nextstate[10] = state[1] & opc1;

  //Link PC in call instruction
  assign nextstate[11] = state[10];

  //Update program counter
  assign nextstate[12] = state[3] | state[5] | state[7] | state[9] | state[11];
  
endmodule // NextStateLogic