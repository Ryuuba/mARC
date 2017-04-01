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
    reg[15:0] r0;
    reg[15:0] r1;
    reg[15:0] r2;
    reg[15:0] r3;
    reg[15:0] r4;
    reg[15:0] r5;
    reg[15:0] r6;
    reg[15:0] r7;
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
            r0  <= 16'h0000;
            r1  <= 16'h0000;
            r2  <= 16'h0000;
            r3  <= 16'h0000;
            r4  <= 16'h0000;
            r5  <= 16'h0000;
            r6  <= 16'h0000;
            r7  <= 16'h0000;
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
    
    always @ (negedge clk) begin
        case (addrD)
            1:  if(rw) r1 <= data;
            2:  if(rw) r2 <= data; 
            3:  if(rw) r3 <= data;
            4:  if(rw) r4 <= data;
            5:  if(rw) r5 <= data;
            6:  if(rw) r6 <= data;
            7:  if(rw) r7 <= data;
            8:  if(rw) displacement <= data;
            13: if(rw) temp0 <= data;
            14: if(rw) pc <= data;
            15: if(rw) ir <= data;
            default: begin
                r0 <= 16'h0000;
                maskl <= 16'h00FF; //maskl
                pimm4 <= 16'h000F; //pimm4
                nimm4 <= 16'hFFF8; //nimm4
                const2 <= 16'h0002;//const2
            end
        endcase
    end

    always @ (*) begin
        //Bus A
        case (addrA)
          0:  busA <= r0;
          1:  busA <= r1;
          2:  busA <= r2;
          3:  busA <= r3;
          4:  busA <= r4;
          5:  busA <= r5;
          6:  busA <= r6;
          7:  busA <= r7;
          8:  busA <= displacement;
          9:  busA <= maskl;
          10: busA <= pimm4;
          11: busA <= nimm4;
          12: busA <= const2;
          13: busA <= temp0;
          14: busA <= pc;
          default: busA <= ir;
        endcase

        //Bus B
        if (addrB == 4'h0) busB = r0;
        else if (addrB == 4'h1) busB = r1;
        else if (addrB == 4'h2) busB = r2;
        else if (addrB == 4'h3) busB = r3;
        else if (addrB == 4'h4) busB = r4;
        else if (addrB == 4'h5) busB = r5;
        else if (addrB == 4'h6) busB = r6;
        else if (addrB == 4'h7) busB = r7;
        else if (addrB == 4'h8) busB = displacement;
        else if (addrB == 4'h9) busB = maskl;
        else if (addrB == 4'hA) busB = pimm4;
        else if (addrB == 4'hB) busB = nimm4;
        else if (addrB == 4'hC) busB = const2;
        else if (addrB == 4'hD) busB = temp0;
        else if (addrB == 4'hE) busB = pc;
        else busB = ir;
    end

endmodule //Fileregister

`endif
