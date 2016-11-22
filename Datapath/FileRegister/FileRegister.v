`ifndef FILE_REGISTER_V
`define FILE_REGISTER_V

module FileRegister(
    clk,
    reset,
    addrA,
    addrB,
    addrD,
    rw,
    data,
    busA,
    busB,
    ir
);

    localparam width = 16;
    input wire clk, reset, rw; //Clock signal and read/write signal
    input wire[3:0] addrA, addrB, addrD; //Address of buses A, B, and D
    input wire[width-1:0] data;
    output reg[width-1:0] busA, busB;
    reg[width-1:0] register[7:0];//Memory
    reg[width-1:0] displacement;
    reg[width-1:0] maskl;
    reg[width-1:0] pimm4;
    reg[width-1:0] nimm4;
    reg[width-1:0] const2;
    reg[width-1:0] temp0;
    reg[width-1:0] pc;
    output reg[width-1:0] ir;
        
    
    always @ (reset) begin
        if (reset) begin
            register[0]  <= 16'h0000;
            register[1]  <= 16'h0000;
            register[2]  <= 16'h0000;
            register[3]  <= 16'h0000;
            register[4]  <= 16'h0000;
            register[5]  <= 16'h0000;
            register[6]  <= 16'h0000;
            register[7]  <= 16'h0000;
            displacement <= 16'h0000;
            maskl        <= 16'h00FF;
            pimm4        <= 16'h000F;
            nimm4        <= 16'hFFF8;
            const2       <= 16'h0002;
            temp0        <= 16'h0000;
            pc           <= 16'h0000;
            ir           <= 16'h0000;
        end
    end
    
    always @ (posedge clk) begin        
        if (addrD == 4'h1 && rw)
            register[1] <= data;
        else if (addrD == 4'h2 && rw)
            register[2] <= data;
        else if (addrD == 4'h3 && rw)
            register[3] <= data;
        else if (addrD == 4'h4 && rw)
            register[4] <= data;
        else if (addrD == 4'h5 && rw)
            register[5] <= data;
        else if (addrD == 4'h6 && rw)
            register[6] <= data;
        else if (addrD == 4'h7 && rw)
            register[7] <= data;
        else if (addrD == 4'h8 && rw)
            displacement <= data;
        else if (addrD == 4'hD && rw)
            temp0 <= data;
        else if (addrD == 4'hE && rw)
            pc <= data;
        else if (addrD == 4'hF && rw)
            ir <= data;
        else begin
            register[0] <= 16'h0000;
            maskl <= 16'h00FF; //maskl
            pimm4 <= 16'h000F; //pimm4
            nimm4 <= 16'hFFF8; //nimm4
            const2 <= 16'h0002;//const2
        end
    end

    always @ (addrA or addrB) begin
        //Bus A
        if (addrA == 4'h0)
            busA = register[0];
        else if (addrA == 4'h1)
            busA = register[1];
        else if (addrA == 4'h2)
            busA = register[2];
        else if (addrA == 4'h3)
            busA = register[3];
        else if (addrA == 4'h4)
            busA = register[4];
        else if (addrA == 4'h5)
            busA = register[5];
        else if (addrA == 4'h6)
            busA = register[6];
        else if (addrA == 4'h7)
            busA = register[7];
        else if (addrA == 4'h8)
            busA = displacement;
        else if (addrA == 4'h9)
            busA = maskl;
        else if (addrA == 4'hA)
            busA = pimm4;
        else if (addrA == 4'hB)
            busA = nimm4;
        else if (addrA == 4'hC)
            busA = const2;
        else if (addrA == 4'hD)
            busA = temp0;
        else if (addrA == 4'hE)
            busA = pc;
        else
            busA = ir;
        //Bus B
        if (addrB == 4'h0)
            busB = register[0];
        else if (addrB == 4'h1)
            busB = register[1];
        else if (addrB == 4'h2)
            busB = register[2];
        else if (addrB == 4'h3)
            busB = register[3];
        else if (addrB == 4'h4)
            busB = register[4];
        else if (addrB == 4'h5)
            busB = register[5];
        else if (addrB == 4'h6)
            busB = register[6];
        else if (addrB == 4'h7)
            busB = register[7];
        else if (addrB == 4'h8)
            busB = displacement;
        else if (addrB == 4'h9)
            busB = maskl;
        else if (addrB == 4'hA)
            busB = pimm4;
        else if (addrB == 4'hB)
            busB = nimm4;
        else if (addrB == 4'hC)
            busB = const2;
        else if (addrB == 4'hD)
            busB = temp0;
        else if (addrB == 4'hE)
            busB = pc;
        else
            busB = ir;
    end

endmodule //Fileregister

`endif
