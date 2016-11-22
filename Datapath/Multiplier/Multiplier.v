`include "Datapath/Multiplier/PartialProduct.v"

module Multiplier(
  m, q, product
);

  parameter width = 8;
  //ports
  input wire[width-1:0] m, q;
  output wire[2*width-1:0] product;
  //internal signals
  wire[width-1:0] ppcout[width-1:0]; //carry out from PP units
  wire[width-1:1] ppsum[width-1:0];  //sum from PP units
  wire[width-1:0] facout;            //carry out from FA section

  genvar i, j;
  generate
    for (i = 0; i <= width; i = i + 1)
      for (j = 0; j < width; j = j + 1) begin
        if (i == 0) begin //first row
          if (j == 0)
            PartialProduct pp_u(
              1'b0,
              1'b0,
              m[j],
              q[i],
              ppcout[i][j],
              product[i]
            );
          else
            PartialProduct pp_u(
              1'b0,
              1'b0,
              m[j],
              q[i],
              ppcout[i][j],
              ppsum[i][j]
            );
        end
        else if (i == width) begin //last row, full adder section
          if (j == 0)
            PartialProduct pp_u(
              ppcout[i-1][j],
              ppsum[i-1][j+1],
              1'b0, //Note that m equals q in the full adder section
              1'b0,
              facout[j],
              product[i+j]
            );
          else if (j == width-1)
            PartialProduct pp_u(
              ppcout[i-1][j],
              1'b0,
              facout[j-1],
              facout[j-1],
              facout[j],
              product[i+j]
            );
          else
            PartialProduct pp_u(
              ppcout[i-1][j],
              ppsum[i-1][j+1],
              facout[j-1],
              facout[j-1],
              facout[j],
              product[i+j]
            );
        end
        else begin //rsows of the middle
          if (j == 0)
            PartialProduct pp_u(
              ppcout[i-1][j],
              ppsum[i-1][j+1],
              m[j],
              q[i],
              ppcout[i][j],
              product[i]
            );
          else if (j == width-1)
            PartialProduct pp_u(
              ppcout[i-1][j],
              1'b0,
              m[j],
              q[i],
              ppcout[i][j],
              ppsum[i][j]
            );
          else
            PartialProduct pp_u(
              ppcout[i-1][j],
              ppsum[i-1][j+1],
              m[j],
              q[i],
              ppcout[i][j],
              ppsum[i][j]
            );
        end
      end
  endgenerate

endmodule // Multiplier
