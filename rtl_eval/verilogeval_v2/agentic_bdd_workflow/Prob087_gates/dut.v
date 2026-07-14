// ============================================================================
// Module: TopModule
// Purpose: Purely combinational circuit computing seven basic logic gate
//          outputs (AND, OR, XOR, NAND, NOR, XNOR, A-AND-NOT-B) from two
//          single-bit inputs a and b. No clock or reset -- all outputs are
//          pure functions of current inputs (no memory/latching).
// ============================================================================
module TopModule (
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    // @and_gate: out_and = a AND b
    assign out_and   = a & b;

    // @or_gate: out_or = a OR b
    assign out_or    = a | b;

    // @xor_gate: out_xor = a XOR b
    assign out_xor   = a ^ b;

    // @nand_gate / @consistency_nand_and: out_nand = NOT(a AND b) = NOT out_and
    assign out_nand  = ~(a & b);

    // @nor_gate / @consistency_nor_or: out_nor = NOT(a OR b) = NOT out_or
    assign out_nor   = ~(a | b);

    // @xnor_gate / @consistency_xnor_xor: out_xnor = NOT(a XOR b) = NOT out_xor
    assign out_xnor  = ~(a ^ b);

    // @anotb_gate / @consistency_anotb_and: out_anotb = a AND (NOT b)
    assign out_anotb = a & (~b);

    // @consistency_and_or: out_and <= out_or is guaranteed since
    // (a & b) implies (a | b) for all boolean a, b -- structurally true,
    // no extra logic needed.

    // @no_combinational_latching: all outputs above are continuous
    // assignments driven only by combinational expressions of a and b,
    // so there is no memory element or latch inference.

endmodule