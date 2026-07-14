// ============================================================================
// Module: TopModule
// Purpose: Five-state Moore FSM (S0..S4) with two-stage description
//          (state register + next-state/output combinational logic).
//          rst is active-low, asynchronous reset drives state to S0.
//          flag is asserted (Moore output) only in state S4.
// ============================================================================
module TopModule (
    input  wire clk,
    input  wire rst,   // active low
    input  wire data,
    output wire flag
);

    // State encoding for the five valid states
    localparam [2:0] S0 = 3'd0,
                      S1 = 3'd1,
                      S2 = 3'd2,
                      S3 = 3'd3,
                      S4 = 3'd4;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // ------------------------------------------------------------------
    // Stage 1: State register (sequential)
    // Scenario @reset: Reset forces state machine to S0
    // Scenario @reset: Flag remains 0 while reset is held low (via S0 output)
    // ------------------------------------------------------------------
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= S0;   // async active-low reset -> S0
        end else begin
            current_state <= next_state;
        end
    end

    // ------------------------------------------------------------------
    // Stage 2: Next-state combinational logic
    // Scenario @transition @S0..@S4: data-dependent transitions
    // Scenario @safety: state always one of 5 valid states (default case)
    // Scenario @safety: no direct jump to S4 except from S3
    // Scenario @liveness: holding data=1 for 4 cycles reaches S4 from S0
    // Scenario @liveness: holding data=0 keeps current state (except S4 loops to S0)
    // ------------------------------------------------------------------
    always @(*) begin
        case (current_state)
            S0: begin
                // From S0: data=1 -> S1, data=0 -> stay S0
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // From S1: data=1 -> S2, data=0 -> stay S1
                if (data)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                // From S2: data=1 -> S3, data=0 -> stay S2
                if (data)
                    next_state = S3;
                else
                    next_state = S2;
            end

            S3: begin
                // From S3: data=1 -> S4, data=0 -> stay S3
                // (only path that reaches S4, satisfying safety scenario)
                if (data)
                    next_state = S4;
                else
                    next_state = S3;
            end

            S4: begin
                // From S4: data=1 -> S1, data=0 -> S0
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end

            default: begin
                // Safety: any invalid/undefined state recovers to S0
                next_state = S0;
            end
        endcase
    end

    // ------------------------------------------------------------------
    // Moore output logic: flag asserted only in state S4
    // Scenario @output: flag = 1 iff current_state == S4
    // Scenario @output: flag depends only on current_state (not on data)
    // ------------------------------------------------------------------
    assign flag = (current_state == S4) ? 1'b1 : 1'b0;

endmodule