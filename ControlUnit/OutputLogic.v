module OutputLogic(
  state,  //current state
  status, //signals from processor status register
  ir, //the value of the instruction register
  ctrlword,  //a 18-bit control word to manage the datapath
  rw_mem //signal asserted when the main memory is asserted
);

  input  wire[12:0] state;
  input  wire[4:0]  status;
  input  wire[15:0] ir; //instruction
  output wire[19:0] ctrlword;
  output wire       rw_mem;

  //Address A[3]
  assign ctrlword[19] = state[0]  | 
                        state[2]  & ir[4] |
                        state[5]  |
                        state[6]  & (ir[10] | ir[9] |ir[8]) |
                        state[7]  |
                        state[8]  |
                        state[9]  |
                        state[10] |
                        state[11] |
                        state[12] & (~status[4] | ~ir[15]&(ir[10] | ir[9] | ir[8]));
  //Address A[2]
  assign ctrlword[18] = state[0]  |
                        state[2]  & (~ir[4] & ir[2] | ir[4])|
                        state[3]  & ir[7] |
                        state[4]  & ir[7] |
                        state[5]  |
                        state[6]  |
                        state[7]  |
                        state[8] & ~ir[11] |
                        state[9]  |
                        state[10] |
                        state[11] |
                        state[12] & (~status[4] | ~ir[15]&(ir[10] | ir[9] | ir[8]));

  //Address A[1]
  assign ctrlword[17] = state[0] |
                        state[2] & (~ir[4] & ir[1] | ir[4]) |
                        state[3] & ir[6] |
                        state[4] & ir[6] |
                        state[6] |
                        state[8] |
                        state[9] & ir[11] |
                        state[10] |
                        state[11] |
                        state[12] & (~status[4] | ~ir[15]&(ir[10] | ir[9] | ir[8]));
  
  //Address A[0]
  assign ctrlword[16] = state[2] & (~ir[4] & ir[0] | ir[4]) |
                        state[3] & ir[5] |
                        state[4] & ir[5] |
                        state[5] |
                        state[6] |
                        state[7] |
                        state[8] & ~ir[11]|
                        state[9] |
                        state[11];
 
  //Address B[3]
  assign ctrlword[15] = state[2] & ir[4] |
                        state[3] |
                        state[6] & ~(ir[10] | ir[9] |ir[8])|
                        state[7] |
                        state[8] |
                        state[9] |
                        state[10] |
                        state[11] |
                        state[12];
  //Address B[2]
  assign ctrlword[14] = state[2] & ir[2] |
                        state[3] |
                        state[4] & ir[2] |
                        state[5] & ir[10] |
                        state[6] & ~(ir[10 | ir[9] | ir[8]]) |
                        state[7] |
                        state[9] |
                        state[10] |
                        state[11] |
                        state[12] & ~status[4];
  //Address B[1]
  assign ctrlword[13] = state[2] & (~ir[4] & ir[1] | ir[4]) |
                        state[4] & ir[1] |
                        state[5] & ir[9] |
                        state[8] & ir[11] |
                        state[10] |
                        state[11];
  //Address B[0]
  assign ctrlword[12] = state[2] & (~ir[4] & ir[0] | ir[4] & ir[3]) |
                        state[3] |
                        state[4] & ir[0] |
                        state[5] & ir[8] |
                        state[7] |
                        state[8] |
                        state[9] |
                        state[11];
  //Address D[3]
  assign ctrlword[11]  = ~(state[1] |
                          state[3] | 
                          state[5] |
                          state[9] |
                          state[10]);

  //Address D[2]
  assign ctrlword[10]  = state[0] |
                        state[2] |
                        state[3] & ir[10] |
                        state[4] |
                        state[5] & ir[10] |
                        state[6] |
                        state[8] |
                        state[9] & ir[10] |
                        state[10] |
                        state[12];
  
  //Address D[1]
  assign ctrlword[9]  = state[0] |
                        state[3] & ir[9] |
                        state[5] & ir[9] |
                        state[9] & ir[9] |
                        state[10] |
                        state[12];
  
  //Address D[0]
  assign ctrlword[8]  = state[0] |
                        state[2] |
                        state[3] & ir[8] |
                        state[4] |
                        state[5] & ir[8] |
                        state[6] |
                        state[8] |
                        state[9] & ir[8] |
                        state[10];
  //rw file register
  assign ctrlword[7]  = ~(state[1] | 
                          state[5] & ir[11]);
  //Data selection
  assign ctrlword[6]  = state[0] |
                        state[5] & ~ir[11];

  //Write PSR
  //TODO Revisar la ecuación
  assign ctrlword[5]  =     (state[3] & ~ir[4]  &  ir[3]) |
                             state[7] & ((~ir[10] & ~ir[9] & ~ir[8]) | //jump
                                         (~ir[10] & ~ir[9] &  ir[8]) | //ba
                            (~status[0] & ~ir[10] &  ir[9] & ~ir[8]) | //bne
                             (status[0] & ~ir[10] &  ir[9] &  ir[8]) | //be
 (~status[0] & ~(status[1] ^ status[2]) &  ir[10] & ~ir[9] & ~ir[8] )| //bg
((status[0] |  (status[1] ^ status[2])) &  ir[10] & ~ir[9] &  ir[8]) | //ble
              (~(status[1] ^ status[2]) &  ir[10] &  ir[9] & ~ir[8]) | //bge
               ((status[1] ^ status[2]) &  ir[10] &  ir[9] &  ir[8]) ) |//bl
                             state[11] |
                             state[12] & status[4];
  //set displacement             
  assign ctrlword[4] = state[7] | state[11];

  
  //operational code[3]
  assign ctrlword[3]  = state[3] & ir[14] |
                        state[6] & (ir[10] | ir[9] |ir[8]) |
                        state[9] & ir[11];
  
  //operational code[2]
  assign ctrlword[2]  = state[3] & ir[13] |
                        state[4] |
                        state[6] |
                        state[9] & ir[11] |
                        state[11] |
                        state[12];

  //operational code[1]
  assign ctrlword[1]  = state[3] & ir[12] |
                        state[6] & (ir[10] | ir[9] | ir[8]);

  //operational code[0]
  assign ctrlword[0]  = state[2] & ir[4] & ir[3] |
                        state[3] & ir[11] |
                        state[4] & ir[4];

  assign rw_mem = state[5] & ir[11];

endmodule // OutputLogic
