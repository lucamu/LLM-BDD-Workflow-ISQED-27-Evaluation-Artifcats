//=============================================================================
// Module: TopModule
// Purpose: Three-Flip-Flop FSM with XOR/AND/OR feedback next-state logic
//          and a NOR-based output z.
//
//   Q_xor next = x XOR Q_xor
//   Q_and next = x AND (NOT Q_and)
//   Q_or  next = x OR  (NOT Q_or)
//   z          = NOT (Q_xor OR Q_and OR Q_or)
//
// All flip-flops are initialized to 0 (reset state) before operation begins.
//=============================================================================
module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal flip-flop state registers
    // @reset @initial_state: all flip-flops start at 0
    reg Q_xor;
    reg Q_and;
    reg Q_or;

    // Initialize state to zero (models "reset before machine begins")
    initial begin
        Q_xor = 1'b0;
        Q_and = 1'b0;
        Q_or  = 1'b0;
    end

    //-------------------------------------------------------------------
    // @next_state @xor_gate
    // XOR flip-flop: D = x XOR Q_xor
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        Q_xor <= x ^ Q_xor;
    end

    //-------------------------------------------------------------------
    // @next_state @and_gate
    // AND flip-flop: D = x AND (NOT Q_and)
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        Q_and <= x & (~Q_and);
    end

    //-------------------------------------------------------------------
    // @next_state @or_gate
    // OR flip-flop: D = x OR (NOT Q_or)
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        Q_or <= x | (~Q_or);
    end

    //-------------------------------------------------------------------
    // @output_logic @nor_gate
    // @combined_transition
    // @stability @no_uninitialized_transitions
    // z is the NOR of all three flip-flop outputs:
    //   z = 1 iff Q_xor = 0 AND Q_and = 0 AND Q_or = 0
    //   z = 0 if any of Q_xor, Q_and, Q_or is 1
    //-------------------------------------------------------------------
    assign z = ~(Q_xor | Q_and | Q_or);

endmodule