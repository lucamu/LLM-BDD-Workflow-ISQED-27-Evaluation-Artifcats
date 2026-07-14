// ============================================================================
// Module: TopModule
// Purpose: 4-bit Full Adder with Overflow
//          Computes the 5-bit sum of two 4-bit unsigned operands x and y.
//          sum[3:0] holds the modular (mod 16) result, sum[4] holds the
//          carry-out/overflow bit indicating whether X + Y >= 16.
// ============================================================================
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    // ------------------------------------------------------------------
    // @arithmetic @core, @overflow @msb, @lowerbits, @zero, @identity,
    // @commutative, @maxvalue, @nooverflow
    //
    // A single 5-bit addition with zero-extended operands naturally
    // satisfies all the scenarios above:
    //   - sum = X + Y  (arithmetic scenario)
    //   - sum[4] is the carry-out, set when X+Y >= 16 (overflow scenario)
    //   - sum[3:0] = (X+Y) mod 16 (lowerbits scenario)
    //   - x=0,y=0 => sum=0 (zero scenario)
    //   - y=0 => sum = x ; x=0 => sum = y (identity scenarios)
    //   - addition is inherently commutative (commutative scenario)
    //   - x=1111,y=1111 => sum = 5'b11110 (maxvalue scenario)
    //   - when X+Y < 16, sum[4]=0 and sum[3:0]=X+Y (nooverflow scenario)
    // ------------------------------------------------------------------
    assign sum = {1'b0, x} + {1'b0, y};

endmodule