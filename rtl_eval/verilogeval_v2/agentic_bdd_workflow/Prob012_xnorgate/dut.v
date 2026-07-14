//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Combinational XNOR gate.
//          Implements out = a XNOR b = NOT(a XOR b)
//
// Scenarios covered:
//   - xnor-truth-table       : out=1 when a==b, out=0 when a!=b
//   - xnor-algebraic         : out = ~(a ^ b)
//   - xnor-both-zero         : a=0,b=0 -> out=1
//   - xnor-both-one          : a=1,b=1 -> out=1
//   - xnor-differing-a0-b1   : a=0,b=1 -> out=0
//   - xnor-differing-a1-b0   : a=1,b=0 -> out=0
//   - xnor-symmetry          : swapping a,b yields same out (inherent to XNOR)
//   - xnor-self-complement   : a, b=~a -> out=0
//   - xnor-self-equal        : a, b=a  -> out=1
//   - xnor-no-dependency-on-history : purely combinational, no state
//------------------------------------------------------------------------
module TopModule (
    input  a,
    input  b,
    output out
);

    // Combinational XNOR logic: out = NOT(a XOR b)
    // Covers all truth-table cases (00->1, 11->1, 01->0, 10->0)
    // Symmetric in a and b by definition of XOR/XNOR.
    // Depends only on current a,b (no registers/state), satisfying
    // the no-history-dependency requirement.
    assign out = ~(a ^ b);

endmodule