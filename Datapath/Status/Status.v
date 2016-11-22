`ifndef STATUS_V
`define STATUS_V

module Status(data, cin, G, P, lastcarry, flag);

    parameter width = 16;
    
    input wire[width-1:0] data;
    input wire cin, G, P, lastcarry;
    output wire[3:0] flag;

    assign flag[0] = ~|data; //Z
    assign flag[1] = data[width-1]; //N
    assign flag[2] = G | (P&cin); //C
    assign flag[3] = lastcarry^flag[2]; //V

endmodule

`endif
