// ============================================================================
// Module: TopModule
// Purpose: Combinational 4-input minimum value selector.
//          Computes min(a, b, c, d) for 8-bit unsigned inputs.
// ============================================================================
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Internal registers for pairwise minimum computation
    reg [7:0] min_ab;   // minimum of a and b
    reg [7:0] min_cd;   // minimum of c and d
    reg [7:0] min_all;  // minimum of all four inputs

    always @(*) begin
        // Step 1: compare a and b -> min_ab
        // Covers @selection scenarios where a or b could be the smaller of the pair
        if (a <= b)
            min_ab = a;
        else
            min_ab = b;

        // Step 2: compare c and d -> min_cd
        // Covers @selection scenarios where c or d could be the smaller of the pair
        if (c <= d)
            min_cd = c;
        else
            min_cd = d;

        // Step 3: compare min_ab and min_cd -> min_all
        // This final comparison ensures:
        //  - @bound: result <= a, <= b, <= c, <= d
        //  - @membership: result equals one of a, b, c, d
        //  - @a_is_min, @b_is_min, @c_is_min, @d_is_min: correct selection
        //  - @equality: when all equal, result equals common value
        //  - @zero: if any input is 0, result is 0
        //  - @max: only 0xFF when all inputs are 0xFF
        if (min_ab <= min_cd)
            min_all = min_ab;
        else
            min_all = min_cd;
    end

    // Output assignment
    // @no_state: purely combinational, no hidden state, same inputs always
    // produce the same output.
    assign min = min_all;

endmodule