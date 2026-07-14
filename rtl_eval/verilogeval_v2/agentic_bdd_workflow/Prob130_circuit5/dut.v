// ============================================================================
// Module: TopModule
// Purpose: 4-to-1 combinational multiplexer with default constant output.
//          Selector 'c' chooses among inputs a, b, d, e:
//            c == 0 -> q = b
//            c == 1 -> q = e
//            c == 2 -> q = a
//            c == 3 -> q = d
//            otherwise (c in [4..F]) -> q = 4'hF (constant default)
// ============================================================================
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(*) begin
        case (c)
            4'h0: q_reg = b;      // @mux-select-0: c==0 -> q = B
            4'h1: q_reg = e;      // @mux-select-1: c==1 -> q = E
            4'h2: q_reg = a;      // @mux-select-2: c==2 -> q = A
            4'h3: q_reg = d;      // @mux-select-3: c==3 -> q = D
            default: q_reg = 4'hF; // @mux-default-low/@mux-default-high: c>=4 -> q = 4'hF
        endcase
    end

    assign q = q_reg; // @mux-exhaustive, @no-x-propagation: fully defined for all c values

endmodule