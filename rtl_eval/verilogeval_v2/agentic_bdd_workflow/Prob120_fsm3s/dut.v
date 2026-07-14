// =============================================================================
// Module: TopModule
// Purpose: 4-state Moore FSM (A, B, C, D) with synchronous active-high reset.
//          Output depends only on current state (Moore semantics).
//
// State encoding:
//   A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
//
// Transition table (@transition scenarios):
//   A: in=0 -> A, in=1 -> B
//   B: in=0 -> C, in=1 -> B
//   C: in=0 -> A, in=1 -> D
//   D: in=0 -> C, in=1 -> B
//
// Output table (@output scenarios):
//   A -> 0, B -> 0, C -> 0, D -> 1
//
// Reachability (@reachability): D is only reached from C when in=1,
// which is guaranteed by the transition table (no other state/input
// combination produces next-state D).
// =============================================================================
module TopModule (
    input  wire clk,
    input  wire in,
    input  wire reset,
    output wire out
);

    // State encoding (local parameters, satisfies "exactly four states" invariant)
    localparam [1:0] A = 2'b00,
                      B = 2'b01,
                      C = 2'b10,
                      D = 2'b11;

    reg [1:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register: synchronous active-high reset
    // Implements @reset scenarios: reset forces state A regardless of
    // current state S and input X.
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            state <= A;          // Synchronous reset forces state A
        else
            state <= next_state; // Normal state update
    end

    // -------------------------------------------------------------------
    // Combinational next-state logic
    // Implements @transition scenarios for each state.
    // Always includes default case to avoid latches.
    // -------------------------------------------------------------------
    always @(*) begin
        case (state)
            A: begin
                // Transition from state A
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Transition from state B
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                // Transition from state C
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                // Transition from state D
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: next_state = A; // Safety default, unreachable in practice
        endcase
    end

    // -------------------------------------------------------------------
    // Moore output logic: depends only on current state (@output, @invariant)
    // Registered output to match "use registered outputs" requirement.
    // -------------------------------------------------------------------
    reg out_reg;

    always @(posedge clk) begin
        if (reset)
            out_reg <= 1'b0; // out should be 0 in the next state after reset
        else begin
            case (next_state)
                A: out_reg <= 1'b0;
                B: out_reg <= 1'b0;
                C: out_reg <= 1'b0;
                D: out_reg <= 1'b1;
                default: out_reg <= 1'b0;
            endcase
        end
    end

    assign out = out_reg;

endmodule