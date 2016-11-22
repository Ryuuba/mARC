//Author: Adán G. Medrano-Chávez
`ifndef PSR_V
`define PSR_V

module ProcessorStatusRegister(
    clk,          //clk signal
    reset,        //reset signal
    rw,           //PSR_rw signal
    displacement, //the set-displacement signal
    flags,        //status of an operation (V, C, Z, N)
    status        //the content of the PSR register
);


    input wire clk, reset, rw, displacement;
    input wire[3:0] flags;
    output reg[4:0] status;
    
    always @ (posedge clk or reset) begin
        if (rw) begin
            status <= {displacement,flags};
        end
        if (reset) begin
            status <= 5'b00000;
        end
    end

endmodule

`endif
