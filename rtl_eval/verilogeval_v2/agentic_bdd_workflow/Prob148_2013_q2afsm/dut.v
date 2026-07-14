// =============================================================================
// Module: TopModule
// Purpose: Priority-based synchronous arbiter FSM with states A, B, C, D.
//          Device 0 has highest priority, device 1 medium, device 2 lowest.
//          A granted device retains its grant as long as it keeps requesting.
// =============================================================================
module TopModule (
    input  wire       clk,
    input  wire       resetn,
    input  wire [2:0] r,
    output wire [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // -------------------------------------------------------------------
    // Sequential state register with synchronous active-low reset
    // (@reset scenario: resetn=0 forces next state to A)
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (!resetn)
            state <= A;             // @reset: synchronous reset forces state A
        else
            state <= next_state;
    end

    // -------------------------------------------------------------------
    // Combinational next-state logic (priority arbitration)
    // -------------------------------------------------------------------
    always @(*) begin
        // Default: stay in current state (avoids latches, complete branches)
        next_state = state;

        case (state)
            // @state_A scenarios: priority device0 > device1 > device2
            A: begin
                if (r[0])
                    next_state = B;      // @state_A @priority_device0
                else if (r[1])
                    next_state = C;      // @state_A @priority_device1
                else if (r[2])
                    next_state = D;      // @state_A @priority_device2
                else
                    next_state = A;      // @state_A @no_request
            end

            // @state_B scenarios: hold grant while r0 requesting, else release
            B: begin
                if (r[0])
                    next_state = B;      // @state_B @hold
                else
                    next_state = A;      // @state_B @release
            end

            // @state_C scenarios: hold grant while r1 requesting, else release
            C: begin
                if (r[1])
                    next_state = C;      // @state_C @hold
                else
                    next_state = A;      // @state_C @release
            end

            // @state_D scenarios: hold grant while r2 requesting, else release
            D: begin
                if (r[2])
                    next_state = D;      // @state_D @hold
                else
                    next_state = A;      // @state_D @release
            end

            default: next_state = A;     // safety default, avoids incomplete case
        endcase
    end

    // -------------------------------------------------------------------
    // Output mapping: grant vector depends only on current state
    // (@output_mapping, @mutual_exclusion, @stability scenarios)
    // -------------------------------------------------------------------
    assign g[0] = (state == B);   // @output_mapping @state_B
    assign g[1] = (state == C);   // @output_mapping @state_C
    assign g[2] = (state == D);   // @output_mapping @state_D
    // In state A, g = 3'b000 (@output_mapping @state_A)
    // Since g is a one-hot decode of a single state register, at most one
    // bit of g can be asserted at any time (@mutual_exclusion), and g is
    // purely a function of 'state' (not r directly), satisfying @stability.

endmodule