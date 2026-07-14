// =============================================================
// Module: TopModule
// Purpose: FSM that detects when a 3-cycle window of the input
//          'w' contains exactly two logic-1 samples.  The FSM
//          starts (leaves the idle/reset state A) only after 's'
//          has been observed high, then monitors 3 consecutive
//          cycles of 'w'.  One cycle after the window completes,
//          'z' is asserted if the sum of the three samples equals
//          2.  A new 3-cycle window begins immediately, using the
//          w value sampled on the very cycle 'z' is produced as
//          the first sample of the new window.
// =============================================================
module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

    // ---------------------------------------------------------
    // State encoding
    //   A  : idle / reset state, waiting for s to go high
    //   B1 : first  sample of the 3-cycle window
    //   B2 : second sample of the 3-cycle window
    //   B3 : third  sample of the 3-cycle window (produces z next cycle)
    // ---------------------------------------------------------
    localparam [1:0] A  = 2'd0,
                      B1 = 2'd1,
                      B2 = 2'd2,
                      B3 = 2'd3;

    reg [1:0] state;      // current FSM state
    reg [1:0] count;      // running count of 1's seen so far in the window (0..3)
    reg       z_reg;      // registered output

    assign z = z_reg;

    // ---------------------------------------------------------
    // Sequential logic: synchronous active-high reset,
    // state transitions, counting, and z generation.
    // ---------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset @safety : synchronous reset forces state A, z=0
            // @reset_priority @safety : reset overrides any partial window count
            state  <= A;
            count  <= 2'd0;
            z_reg  <= 1'b0;
        end else begin
            case (state)
                // -------------------------------------------------
                // @idle @safety / @transition @safety
                // Stay in A while s==0; leave A only when s==1.
                // z stays 0 while in A (or transitioning out of A).
                // -------------------------------------------------
                A: begin
                    if (s)
                        state <= B1;   // leave A, begin monitoring window
                    else
                        state <= A;    // remain idle
                    count <= 2'd0;
                    z_reg <= 1'b0;     // @z_default : z=0 in A
                end

                // -------------------------------------------------
                // First sample of the 3-cycle window.
                // @core @functional / @s_ignored @safety
                // (s has no effect here; only w and progress matter)
                // -------------------------------------------------
                B1: begin
                    state <= B2;
                    count <= {1'b0, w};   // first sample counted
                    z_reg <= 1'b0;        // @z_default
                end

                // -------------------------------------------------
                // Second sample of the 3-cycle window.
                // -------------------------------------------------
                B2: begin
                    state <= B3;
                    count <= count + {1'b0, w}; // accumulate second sample
                    z_reg <= 1'b0;               // @z_default
                end

                // -------------------------------------------------
                // Third sample of the 3-cycle window.
                // Compute z for the completed window (registered,
                // appears on the following cycle).
                // @core @functional : z=1 iff sum of 3 samples == 2
                // @continuous @functional : new window begins next
                //   cycle at state B1, and the w sampled during THIS
                //   output cycle (handled by B1 logic) becomes the
                //   first sample of the new window.
                // -------------------------------------------------
                B3: begin
                    state <= B1; // immediately start new window
                    z_reg <= ((count + {1'b0, w}) == 2'd2) ? 1'b1 : 1'b0;
                    // count will be overwritten by B1 logic next cycle
                end

                // -------------------------------------------------
                // Default: safety net, should not occur.
                // -------------------------------------------------
                default: begin
                    state <= A;
                    count <= 2'd0;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

endmodule