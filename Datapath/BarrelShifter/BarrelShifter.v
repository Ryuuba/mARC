/* Author: Adán G. Medrano-Chávez
   This module implements a barrel shifter able to do both shifts and
   rotations to the right and left. The input operand is a width-bit vector
   A, the number of shifts/rotations is a log2(A)-bit vector named B, the
   operational code is a two-bit vector named opcode, and 
   the output is a width-bit vector Y. This module operates according to 
   the following table

   opcode  |  operation
   --------------------------------
   00      |  shift logical right
   01      |  shift logical left
   10      |  rotation right
   11      |  rotation left
   
   in both direction 
 */

`ifndef BARREL_SHIFTER_V
`define BARREL_SHIFTER_V
`include "Datapath/BarrelShifter/RightShifterRotator.v"
`include "Datapath/BarrelShifter/Reversal.v"

module BarrelShifter(a, b, opcode, y);

   parameter width = 16;
   localparam level = $clog2(width);

   input[width-1:0] a;
   input[level-1:0] b;
   input[1:0] opcode;
   output[width-1:0] y;

   wire[width-1:0] a, y;
   wire[level-1:0] b;
   wire[1:0] opcode;
   wire[width-1:0] reversal_signal_out;
   wire[width-1:0] rsr_signal_out;

   defparam reversal_top.width = width;
   Reversal reversal_top(a, opcode[0], reversal_signal_out);
   defparam rsr.width = width;
   RightShifterRotator rsr(reversal_signal_out, b, opcode[1], rsr_signal_out);
   defparam reversal_down.width = width;
   Reversal reversal_down(rsr_signal_out, opcode[0], y);

endmodule

`endif
