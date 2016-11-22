`ifndef FUNCTIONAL_UNIT_V
`define FUNCTIONAL_UNIT_V

`include "Datapath/BarrelShifter/BarrelShifter.v"
`include "Datapath/HCLA/HCLA.v"
`include "Datapath/LogicUnit/LogicUnit.v"
`include "Datapath/Multiplier/Multiplier.v"
`include "Datapath/Basic/Mux4x2p.v"
`include "Datapath/Basic/Inverter.v"
`include "Datapath/Status/Status.v"

module FunctionalUnit(a, b, opcode, y, status);

    parameter width = 16;

    input wire[width-1:0] a, b;
    input wire[3:0] opcode;
    output wire[width-1:0] y;
    output wire[3:0] status;

    wire[width-1:0] functional_out[3:0], bneg;
    wire lastcarry, G, P;

    LogicUnit logic_u(a, b, opcode[1:0], functional_out[0]);

    defparam inverter_u.width = width;
    Inverter inverter_u(b, opcode[0], bneg);
    HierarchicalCLA adder_u(a, bneg, opcode[0], functional_out[1], 
                            lastcarry, G, P);

    Multiplier mult_u(a[7:0], b[7:0], functional_out[2]);
    
    BarrelShifter barrel_u(a, b[3:0], opcode[1:0], functional_out[3]);

    defparam mux_u.width = width;
    Mux4x2 mux_u(functional_out[0], functional_out[1], functional_out[2], 
                 functional_out[3], opcode[3:2], y);

    Status status_u(y, opcode[0], G, P, lastcarry, status);

endmodule

`endif
