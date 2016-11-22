/* Author: Adán G. Medrano-Chávez
   This module implements a barrel shifter able to do both shifters and
   rotations to the right and left. The input operand is a width-bit vector
   A, the number of shifters/rotations is a log2(A)-bit vector named B, the
   operational code is a two-bit vector named opcode, and 
   the output is a width-bit vector Y. This module operates according to 
   the following table

   opcode  |  operation
   --------------------------------
   00      |  shifter logical right
   01      |  shifter logica left
   10      |  rotation right
   11      |  rotation left
   
   in both direction 
 */

`ifndef RIGHT_SHIFTER_ROTATOR_V
`define RIGHT_SHIFTER_ROTATOR_V
`include "Datapath/Basic/Mux2x1p.v"

module RightShifterRotator(a, b, opcode, y);

   parameter width = 8;
   localparam level = $clog2(width);

   input[width-1:0] a;
   input[level-1:0] b;
   input opcode;
   output[width-1:0] y;
   
   wire[width-1:0] a, y;
   wire[level-1:0] b;
   wire opcode;

   wire[width-1:0] shifter[level-2:0];
   wire[width-2:0] rotator;

   genvar i, j;
   generate
      for (i=0; i<level; i=i+1)
      begin
         for (j=0; j<width; j=j+1)
         begin
            if (i==0)
            begin
               if(j < width-2**i)
                  Mux2x1 mux_shifter(shifter[i][j], shifter[i][j+2**i], b[i], y[j]);
               else
               begin
                  Mux2x1 mux_shifter(shifter[i][j], rotator[2**i+j%(width-2**i)-1], b[i], y[j]);
                  Mux2x1 mux_rotator(1'b0, shifter[i][j%(width-2**i)], opcode, rotator[2**i+j%(width-2**i)-1]);
               end
            end
            else if (i==(level-1))
            begin
               if(j < width-2**i)
                  Mux2x1 mux_shifter(a[j], a[j+2**i], b[i], shifter[i-1][j]);
               else
               begin
                  Mux2x1 mux_shifter(a[j], rotator[2**i+j%(width-2**i)-1], b[i], shifter[i-1][j]);
                  Mux2x1 mux_rotator(1'b0, a[j%(width-2**i)], opcode, rotator[2**i+j%(width-2**i)-1]);
               end
            end
            else
            begin
               if(j < width-2**i)
                  Mux2x1 mux_shifterer(shifter[i][j], shifter[i][j+2**i], b[i], shifter[i-1][j]);
               else
               begin
                  Mux2x1 mux_shifterer(shifter[i][j], rotator[2**i+j%(width-2**i)-1], b[i], shifter[i-1][j]);
                  Mux2x1 mux_rotator(1'b0, shifter[i][j%(width-2**i)], opcode, rotator[2**i+j%(width-2**i)-1]);
               end 
            end
         end
      end
   endgenerate
endmodule

`endif
