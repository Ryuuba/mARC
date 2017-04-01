`ifndef MUX2X1_V
`define	MUX2X1_V

module Mux2x1(a, b, sel, y);
	
  parameter width = 1;
  input wire[width-1:0] a, b;
  input wire sel;
	output reg[width-1:0] y;
	
	always @(*) begin
		if (sel == 1'b0)
			y = a;
		else 
			y = b;
	end

endmodule

`endif