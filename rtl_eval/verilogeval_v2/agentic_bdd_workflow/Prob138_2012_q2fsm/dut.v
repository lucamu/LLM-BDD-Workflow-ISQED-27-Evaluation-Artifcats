//=============================================================================
// Module: TopModule
// Purpose: Moore FSM with 6 states (A-F). States E and F output z=1,
//          all other states output z=0. Synchronous active-high reset
//          forces state A. Transitions are determined by input w.
//=============================================================================
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    // State encoding
    localparam [2:0] A = 3'd0,
                      B = 3'd1,
                      C = 3'd2,
                      D = 3'd3,
                      E = 3'd4,
                      F = 3'd5;

    reg [2:0] current_state, next_state;

    //-------------------------------------------------------------------
    // Sequential logic: state register
    // Scenario: Synchronous reset forces state A (reset -> A)
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            current_state <= A;          // @reset scenario
        else
            current_state <= next_state; // normal state update
    end

    //-------------------------------------------------------------------
    // Combinational next-state logic
    // Implements @state_X @transition scenarios and @totality
    //-------------------------------------------------------------------
    always @(*) begin
        case (current_state)
            // @state_A @transition: A -> B on w=1, A -> A on w=0
            A: next_state = w ? B : A;

            // @state_B @transition: B -> C on w=1, B -> D on w=0
            B: next_state = w ? C : D;

            // @state_C @transition: C -> E on w=1, C -> D on w=0
            C: next_state = w ? E : D;

            // @state_D @transition: D -> F on w=1, D -> A on w=0
            D: next_state = w ? F : A;

            // @state_E @transition: E -> E on w=1, E -> D on w=0
            E: next_state = w ? E : D;

            // @state_F @transition: F -> C on w=1, F -> D on w=0
            F: next_state = w ? C : D;

            // Default case avoids latches; totality/deadlock_freedom guarantee
            default: next_state = A;
        endcase
    end

    //-------------------------------------------------------------------
    // Moore output logic: depends only on current_state
    // @state_A/@state_B/@state_C/@state_D @output -> z = 0
    // @state_E/@state_F @output -> z = 1
    // @output_consistency scenario
    //-------------------------------------------------------------------
    assign z = (current_state == E) || (current_state == F);

endmodule