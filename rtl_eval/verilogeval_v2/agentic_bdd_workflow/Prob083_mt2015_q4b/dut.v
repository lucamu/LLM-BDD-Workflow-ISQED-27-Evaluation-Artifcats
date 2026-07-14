// ============================================================
// Module: TopModule
// Purpose: Combinational logic implementing the XNOR function
//          z = ~(x ^ y)
//
// Scenarios implemented:
//   - Output z is the logical XNOR of x and y (exhaustive)
//   - Both inputs low  (x=0,y=0) -> z=1
//   - Only x high      (x=1,y=0) -> z=0
//   - Only y high      (x=0,y=1) -> z=0
//   - Both inputs high (x=1,y=1) -> z=1
//   - Output equals bitwise XNOR expression (~(x^y)) & 1'b1
//   - Output is symmetric w.r.t. inputs (XNOR is commutative,
//     guaranteed by the expression itself)
// ============================================================

module TopModule (
    input  x,
    input  y,
    output z
);

    // Combinational assignment implementing XNOR(x, y)
    // Covers all exhaustive and case scenarios:
    //   x=0,y=0 -> z=1
    //   x=1,y=0 -> z=0
    //   x=0,y=1 -> z=0
    //   x=1,y=1 -> z=1
    // Symmetry holds naturally since (x^y) == (y^x)
    assign z = (~(x ^ y)) & 1'b1;

endmodule