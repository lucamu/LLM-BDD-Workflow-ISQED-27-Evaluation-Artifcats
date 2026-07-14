// ============================================================================
// Module: TopModule
// Purpose: Full Adder combinational logic implementing:
//          sum = a ^ b ^ cin
//          cout = majority(a, b, cin)
// This satisfies all specified formal scenarios:
//  - @core @sum, @core @carry: direct boolean equations
//  - @arithmetic @consistency: {cout,sum} = a+b+cin by construction
//  - @edge @all_zeros, @edge @all_ones: covered by same equations
//  - @symmetry @commutative_ab, @commutative_cin: XOR/majority are symmetric
//    functions of all three inputs, so swapping any two inputs preserves
//    sum and cout values
//  - @no_x_propagation: pure combinational assign with defined logic for
//    all valid 1-bit inputs
//  - @combinational_purity: no internal state, outputs depend only on
//    current inputs (continuous assignment)
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // @core @sum: sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // @core @carry: cout is majority function of all three inputs
    assign cout = (a & b) | (a & cin) | (b & cin);

    // @arithmetic @consistency: {cout, sum} inherently equals a + b + cin
    // since the full adder truth table is derived from binary addition.

    // @edge @all_zeros: a=0,b=0,cin=0 => sum=0, cout=0 (verified by eqns above)
    // @edge @all_ones:  a=1,b=1,cin=1 => sum=1, cout=1 (verified by eqns above)

    // @symmetry: XOR and majority functions are symmetric in a, b, cin,
    // so any permutation of inputs (including swapping a<->b or a<->cin)
    // yields identical sum and cout values.

    // @no_x_propagation & @combinational_purity: continuous assignments
    // guarantee deterministic, glitch-free, stateless combinational outputs.

endmodule