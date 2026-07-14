// ============================================================================
// Module: TopModule
// Purpose: 2-to-1 Multiplexer with Dual Implementation
//          Selects between inputs a and b based on the AND of sel_b1 and
//          sel_b2, implemented once via continuous assignment (out_assign)
//          and once via procedural if statement (out_always).
// ============================================================================
module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

    // -------------------------------------------------------------------
    // Continuous assignment implementation
    // Scenarios: @assign @select_b, @select_a_sel_b1_low,
    //            @select_a_sel_b2_low, @general_equivalence
    // out_assign = b when (sel_b1 & sel_b2) == 1, else a
    // -------------------------------------------------------------------
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    // -------------------------------------------------------------------
    // Procedural if implementation
    // Scenarios: @always @select_b, @select_a_sel_b1_low,
    //            @select_a_sel_b2_low, @general_equivalence
    // out_always = b when (sel_b1 & sel_b2) == 1, else a
    // No latches: both branches fully assign out_always_reg
    // -------------------------------------------------------------------
    reg out_always_reg;
    always @(*) begin
        if (sel_b1 && sel_b2) begin
            // Both select lines true: select b (@select_b)
            out_always_reg = b;
        end else begin
            // sel_b1 false or sel_b2 false: select a
            // (@select_a_sel_b1_low, @select_a_sel_b2_low)
            out_always_reg = a;
        end
    end

    assign out_always = out_always_reg;

    // -------------------------------------------------------------------
    // @equivalence: out_assign and out_always always match since both
    // implementations use the same selection condition (sel_b1 & sel_b2).
    //
    // @no_dependency scenarios are satisfied inherently: when the select
    // condition is false, only 'a' drives the outputs (b is irrelevant),
    // and when the select condition is true, only 'b' drives the outputs
    // (a is irrelevant).
    // -------------------------------------------------------------------

endmodule