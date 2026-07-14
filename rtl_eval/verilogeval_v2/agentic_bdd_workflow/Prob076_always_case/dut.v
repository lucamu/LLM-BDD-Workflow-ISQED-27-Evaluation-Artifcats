// ============================================================================
// Module: TopModule
// Purpose: 6-to-1 combinational multiplexer.
//          Selects one of six 4-bit data inputs based on 3-bit sel.
//          sel = 0..5 -> corresponding data input routed to out.
//          sel = 6,7  -> out = 0 (out-of-range default).
// ============================================================================
module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

    reg [3:0] out_reg;

    // Combinational selection logic - covers scenarios:
    // @select0 .. @select5, @select6_invalid, @select7_invalid,
    // @general_mux_behavior, @independent_of_unselected_data_*,
    // @combinational_determinism (pure combinational, no state)
    always @(*) begin
        case (sel)
            3'b000:  out_reg = data0; // @select0
            3'b001:  out_reg = data1; // @select1
            3'b010:  out_reg = data2; // @select2
            3'b011:  out_reg = data3; // @select3
            3'b100:  out_reg = data4; // @select4
            3'b101:  out_reg = data5; // @select5
            default: out_reg = 4'b0000; // @select6_invalid, @select7_invalid
        endcase
    end

    assign out = out_reg;

endmodule