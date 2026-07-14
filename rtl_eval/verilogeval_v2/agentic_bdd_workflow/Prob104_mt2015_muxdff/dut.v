// ============================================================================
// Module: TopModule
// Purpose: Single-bit D flip-flop preceded by a 2:1 multiplexer.
//          The mux selects between r_in (load value) and q_in (feedback
//          value) based on the load-enable signal L. The selected value
//          is registered on the rising edge of clk to produce Q.
//
//          This block is the fundamental building unit that, when
//          instantiated three times, forms the 3-bit self-shifting
//          register with XOR feedback in full_module.
// ============================================================================
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    // Internal registered output storage
    reg Q_reg;

    // Combinational mux selection signal
    reg mux_out;

    // --------------------------------------------------------------------
    // Combinational multiplexer logic
    // Scenario: mux_selection - selects r_in when L=1, q_in when L=0
    // --------------------------------------------------------------------
    always @(*) begin
        if (L)
            mux_out = r_in;  // Scenario: Loading r_in when L is asserted
        else
            mux_out = q_in;  // Scenario: Passing q_in through when L is deasserted
    end

    // --------------------------------------------------------------------
    // Sequential logic: register the mux output on rising clock edge
    // Scenario: output_registered - Q only changes on rising edge of clk
    // Scenario: stability - Q holds its value when no clock edge occurs
    // Scenario: determinism - Q_reg <= (L ? r_in : q_in) deterministically
    // --------------------------------------------------------------------
    always @(posedge clk) begin
        Q_reg <= mux_out;
    end

    // Continuous assignment of registered value to output port
    assign Q = Q_reg;

endmodule