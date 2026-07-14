// Module: TopModule
// Purpose: 16-bit wide, 9-to-1 combinational multiplexer with 4-bit select.
//          Select values 0-8 route inputs a-i respectively to out.
//          Select values 9-15 (unused) force out to all ones (16'hFFFF).
module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Internal register for combinational output (driven in always block)
    reg [15:0] out_reg;

    // Combinational mux logic - no clock/reset, purely combinational
    always @(*) begin
        case (sel)
            4'b0000: out_reg = a;      // Scenario: select0 -> out = a
            4'b0001: out_reg = b;      // Scenario: select1 -> out = b
            4'b0010: out_reg = c;      // Scenario: select2 -> out = c
            4'b0011: out_reg = d;      // Scenario: select3 -> out = d
            4'b0100: out_reg = e;      // Scenario: select4 -> out = e
            4'b0101: out_reg = f;      // Scenario: select5 -> out = f
            4'b0110: out_reg = g;      // Scenario: select6 -> out = g
            4'b0111: out_reg = h;      // Scenario: select7 -> out = h
            4'b1000: out_reg = i;      // Scenario: select8 -> out = i
            default: out_reg = 16'hFFFF; // Scenarios: unused select values 9-15 -> all ones
        endcase
    end

    // Combinational output assignment (no internal state, matches
    // "combinational @no_state" scenario: depends only on current inputs)
    assign out = out_reg;

endmodule