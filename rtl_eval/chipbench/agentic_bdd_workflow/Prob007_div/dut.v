module TopModule (
    input               clk,
    input               rst,
    input               signed_div_i,
    input      [31:0]   opdata1_i,
    input      [31:0]   opdata2_i,
    input               start_i,
    input               annul_i,
    output     [63:0]   result_o,
    output              ready_o
);

    //-------------------------------------------------------------------
    // FSM state encoding
    //-------------------------------------------------------------------
    localparam STATE_IDLE = 1'b0;
    localparam STATE_BUSY = 1'b1;
    localparam N          = 32;          // fixed bounded latency (cycles)

    // Internal control registers (per specification: state_r, cnt_r)
    reg        state_r;
    reg [5:0]  cnt_r;                    // counts 0..N-1

    // Latched sign/mode info captured at the moment start_i is accepted,
    // used later by ResultCorrection when the calculation completes.
    reg        signed_div_r;
    reg        quotient_sign_r;
    reg        remainder_sign_r;

    // Registered outputs
    reg        ready_r;
    reg [63:0] result_r;

    //-------------------------------------------------------------------
    // Combinational: SignPrep operates on the *live* external operands.
    // Its outputs are consumed by DivCore only during the single cycle
    // that local_start pulses, and its sign outputs are latched into
    // quotient_sign_r/remainder_sign_r at that same moment.
    //-------------------------------------------------------------------
    wire [31:0] dividend_w;
    wire [31:0] divisor_w;
    wire        quotient_sign_w;
    wire        remainder_sign_w;

    dut__SignPrep u_signprep (
        .signed_div_i     (signed_div_i),
        .opdata1_i        (opdata1_i),
        .opdata2_i        (opdata2_i),
        .dividend_o       (dividend_w),
        .divisor_o        (divisor_w),
        .quotient_sign_o  (quotient_sign_w),
        .remainder_sign_o (remainder_sign_w)
    );

    //-------------------------------------------------------------------
    // local_start: pulses exactly one cycle -- only when currently IDLE
    // and start_i is asserted (Scenario: "Asserting start_i captures the
    // operands and begins calculation"). While BUSY, start_i is ignored
    // (Scenario: "start_i is ignored while a calculation is already in
    // progress").
    //-------------------------------------------------------------------
    wire local_start = (state_r == STATE_IDLE) && start_i;

    //-------------------------------------------------------------------
    // DivCore: performs the actual shift-subtract division algorithm
    // with fixed N-cycle latency. It only captures dividend_i/divisor_i
    // when local_start is pulsed, and terminates early without asserting
    // ready_o if annul_i is asserted (Scenarios: annul termination,
    // annul on final busy cycle).
    //-------------------------------------------------------------------
    wire [31:0] divcore_quotient;
    wire [31:0] divcore_remainder;
    wire        divcore_ready;

    dut__DivCore u_divcore (
        .clk         (clk),
        .rst         (rst),
        .start_i     (local_start),
        .annul_i     (annul_i),
        .dividend_i  (dividend_w),
        .divisor_i   (divisor_w),
        .quotient_o  (divcore_quotient),
        .remainder_o (divcore_remainder),
        .ready_o     (divcore_ready)
    );

    //-------------------------------------------------------------------
    // ResultCorrection: applies sign correction using the latched
    // signed_div_r/quotient_sign_r/remainder_sign_r captured at start.
    //-------------------------------------------------------------------
    wire [31:0] corrected_quotient;
    wire [31:0] corrected_remainder;

    dut__ResultCorrection u_rescorr (
        .signed_div_i     (signed_div_r),
        .quotient_sign_i  (quotient_sign_r),
        .remainder_sign_i (remainder_sign_r),
        .quotient_i       (divcore_quotient),
        .remainder_i      (divcore_remainder),
        .quotient_o       (corrected_quotient),
        .remainder_o      (corrected_remainder)
    );

    //-------------------------------------------------------------------
    // Sequential control logic: state_r, cnt_r, ready_r, result_r,
    // and the latched sign/mode information.
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Scenario: "Reset forces the module to an idle, not-ready state"
            // Scenario: "Reset overrides an in-progress calculation"
            state_r          <= STATE_IDLE;
            cnt_r            <= 6'd0;
            ready_r          <= 1'b0;
            result_r         <= 64'd0;
            signed_div_r     <= 1'b0;
            quotient_sign_r  <= 1'b0;
            remainder_sign_r <= 1'b0;
        end else begin
            case (state_r)

                //-------------------------------------------------------
                // STATE_IDLE
                //-------------------------------------------------------
                STATE_IDLE: begin
                    if (start_i) begin
                        // Scenario: "Asserting start_i captures the
                        // operands and begins calculation"
                        state_r          <= STATE_BUSY;
                        cnt_r            <= 6'd0;
                        signed_div_r     <= signed_div_i;
                        quotient_sign_r  <= quotient_sign_w;
                        remainder_sign_r <= remainder_sign_w;
                    end else begin
                        // Scenario: "No calculation begins while start_i
                        // is deasserted"
                        state_r <= STATE_IDLE;
                        cnt_r   <= 6'd0;
                    end
                    // Scenario: "ready_o is asserted for exactly one
                    // cycle upon completion" -- deassert on the very
                    // next cycle regardless of start_i.
                    ready_r <= 1'b0;
                end

                //-------------------------------------------------------
                // STATE_BUSY
                //-------------------------------------------------------
                STATE_BUSY: begin
                    if (annul_i) begin
                        // Scenario: "Asserting annul_i terminates an
                        // in-progress calculation"
                        // Scenario: "Asserting annul_i on the final busy
                        // cycle still suppresses ready_o" (annul takes
                        // priority over a same-cycle divcore_ready).
                        state_r <= STATE_IDLE;
                        cnt_r   <= 6'd0;
                        ready_r <= 1'b0;
                    end else if (divcore_ready) begin
                        // Scenario: "Division completes within a fixed,
                        // bounded latency of N cycles" -- ready_o
                        // asserts and state_r returns to IDLE in the
                        // same cycle.
                        state_r  <= STATE_IDLE;
                        cnt_r    <= 6'd0;
                        ready_r  <= 1'b1;
                        result_r <= {corrected_remainder, corrected_quotient};
                    end else begin
                        // Continue counting cycles while busy.
                        state_r <= STATE_BUSY;
                        cnt_r   <= cnt_r + 6'd1;
                        ready_r <= 1'b0;
                    end
                end

                //-------------------------------------------------------
                // Default: never-reached state, force safe recovery
                //-------------------------------------------------------
                default: begin
                    state_r <= STATE_IDLE;
                    cnt_r   <= 6'd0;
                    ready_r <= 1'b0;
                end
            endcase
        end
    end

    //-------------------------------------------------------------------
    // Output assignments
    // Scenario: "result_o holds its completed value until overwritten
    // by a subsequent operation or reset" -- result_r only updates on
    // a valid completion, otherwise retains its value.
    //-------------------------------------------------------------------
    assign result_o = result_r;
    assign ready_o   = ready_r;

endmodule

module dut__SignPrep (
    input               signed_div_i,
    input  [31:0]       opdata1_i,
    input  [31:0]       opdata2_i,
    output [31:0]       dividend_o,
    output [31:0]       divisor_o,
    output              quotient_sign_o,
    output              remainder_sign_o
);

    // Two's-complement negations of operands (used when sign bit is 1)
    wire [31:0] neg_opdata1 = (~opdata1_i) + 32'd1;
    wire [31:0] neg_opdata2 = (~opdata2_i) + 32'd1;

    // Sign bits of each operand
    wire sign_a = opdata1_i[31];
    wire sign_b = opdata2_i[31];

    // quotient_sign_o = 0 in unsigned mode, else XOR of operand sign bits
    assign quotient_sign_o = signed_div_i & (sign_a ^ sign_b);

    // remainder_sign_o = 0 in unsigned mode, else equals dividend sign bit
    assign remainder_sign_o = signed_div_i & sign_a;

    // dividend_o = operand A unchanged if unsigned mode or sign_a==0,
    // else two's-complement negation (absolute value) of operand A
    assign dividend_o = (signed_div_i & sign_a) ? neg_opdata1 : opdata1_i;

    // divisor_o = operand B unchanged if unsigned mode or sign_b==0,
    // else two's-complement negation (absolute value) of operand B
    assign divisor_o = (signed_div_i & sign_b) ? neg_opdata2 : opdata2_i;

endmodule

module dut__DivCore (
    input               clk,
    input               rst,
    input               start_i,
    input               annul_i,
    input      [31:0]   dividend_i,
    input      [31:0]   divisor_i,
    output reg [31:0]   quotient_o,
    output reg [31:0]   remainder_o,
    output reg          ready_o
);

    // -------------------------------------------------------------------
    // Internal state definitions
    // -------------------------------------------------------------------
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state;          // current FSM state (IDLE / BUSY)
    reg  [63:0] shift_reg;      // {partial_remainder, partial_quotient}
    reg  [31:0] divisor_reg;    // latched divisor
    reg  [4:0]  cycle_cnt;      // iteration counter, 0..31

    // -------------------------------------------------------------------
    // Combinational shift-and-subtract computation
    // (used both by iterative steps and by the final completion step)
    // -------------------------------------------------------------------
    reg [63:0] shifted;
    reg [31:0] new_upper;
    reg        new_lsb;
    reg [63:0] new_shift_reg;

    always @(*) begin
        // Shift the 64-bit {remainder, quotient} register left by one bit
        shifted = {shift_reg[62:0], 1'b0};

        // Compare shifted upper 32 bits (candidate remainder) against divisor
        if (shifted[63:32] >= divisor_reg) begin
            // @busy_iteration_subtract : subtract divisor, set LSB (quotient bit) = 1
            new_upper = shifted[63:32] - divisor_reg;
            new_lsb   = 1'b1;
        end else begin
            // @busy_iteration_no_subtract : keep remainder, LSB (quotient bit) = 0
            new_upper = shifted[63:32];
            new_lsb   = 1'b0;
        end

        new_shift_reg = {new_upper, shifted[31:1], new_lsb};
    end

    // -------------------------------------------------------------------
    // Sequential state / datapath update
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // @reset : force idle state with cleared outputs
            state        <= IDLE;
            shift_reg    <= 64'b0;
            divisor_reg  <= 32'b0;
            cycle_cnt    <= 5'b0;
            ready_o      <= 1'b0;
            quotient_o   <= 32'b0;
            remainder_o  <= 32'b0;
        end else begin
            case (state)

                // -------------------------------------------------------
                // IDLE state
                // -------------------------------------------------------
                IDLE: begin
                    // @ready_single_cycle : ready_o deasserts one cycle after completion
                    ready_o <= 1'b0;

                    if (start_i) begin
                        // @idle_latch_start / @cycle_counter_reset_on_start
                        shift_reg   <= {32'b0, dividend_i};
                        divisor_reg <= divisor_i;
                        cycle_cnt   <= 5'b0;
                        state       <= BUSY;
                    end
                    // @idle_no_start / @annul_idle_noop :
                    // start_i == 0 (regardless of annul_i) -> remain IDLE, ready_o stays 0
                end

                // -------------------------------------------------------
                // BUSY state
                // -------------------------------------------------------
                BUSY: begin
                    if (annul_i) begin
                        // @annul_abort_busy / @annul_mid_sequence_no_result
                        // Immediately abort, no result produced.
                        state   <= IDLE;
                        ready_o <= 1'b0;
                    end else if (cycle_cnt == 5'd31) begin
                        // @completion : final shift-and-subtract step folded into
                        // the completion cycle to produce the correct 32-iteration
                        // division result; ready_o pulses for exactly one cycle.
                        quotient_o  <= new_shift_reg[31:0];
                        remainder_o <= new_shift_reg[63:32];
                        ready_o     <= 1'b1;
                        state       <= IDLE;
                    end else begin
                        // @busy_iteration_subtract / @busy_iteration_no_subtract
                        // @start_ignored_while_busy : start_i has no effect here,
                        // divisor_reg is left untouched.
                        shift_reg <= new_shift_reg;
                        cycle_cnt <= cycle_cnt + 5'b1;
                        ready_o   <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule

module dut__ResultCorrection (
    input               signed_div_i,
    input               quotient_sign_i,
    input               remainder_sign_i,
    input      [31:0]   quotient_i,
    input      [31:0]   remainder_i,
    output     [31:0]   quotient_o,
    output     [31:0]   remainder_o
);

    // -------------------------------------------------------------------
    // Internal combinational signals for negated (two's complement) values
    // -------------------------------------------------------------------
    wire [31:0] quotient_neg;
    wire [31:0] remainder_neg;

    // Two's complement negation: (bitwise NOT) + 1
    // Used in scenarios: signed_quotient_negation, signed_remainder_negation,
    // independence, zero_invariance, zero_invariance_remainder
    assign quotient_neg  = (~quotient_i)  + 32'd1;
    assign remainder_neg = (~remainder_i) + 32'd1;

    // -------------------------------------------------------------------
    // Quotient output selection
    // -------------------------------------------------------------------
    // Scenario: unsigned_passthrough -> when signed_div_i = 0, pass Q through
    // Scenario: signed_quotient_passthrough -> signed_div_i=1, quotient_sign_i=0 -> Q unchanged
    // Scenario: signed_quotient_negation -> signed_div_i=1, quotient_sign_i=1 -> negate Q
    // Scenario: independence -> quotient correction independent of remainder correction
    // Scenario: zero_invariance -> negation of 0 remains 0 (handled naturally by two's complement)
    assign quotient_o = (!signed_div_i) ? quotient_i :
                        (quotient_sign_i ? quotient_neg : quotient_i);

    // -------------------------------------------------------------------
    // Remainder output selection
    // -------------------------------------------------------------------
    // Scenario: unsigned_passthrough -> when signed_div_i = 0, pass R through
    // Scenario: signed_remainder_passthrough -> signed_div_i=1, remainder_sign_i=0 -> R unchanged
    // Scenario: signed_remainder_negation -> signed_div_i=1, remainder_sign_i=1 -> negate R
    // Scenario: independence -> remainder correction independent of quotient correction
    // Scenario: zero_invariance_remainder -> negation of 0 remains 0 (handled naturally)
    assign remainder_o = (!signed_div_i) ? remainder_i :
                          (remainder_sign_i ? remainder_neg : remainder_i);

    // -------------------------------------------------------------------
    // Note: This module has no clock or reset, and outputs depend only on
    // current input values (Scenario: no_state) -- purely combinational
    // logic with no memory across evaluations, as required by the
    // specification's Background statement.
    // -------------------------------------------------------------------

endmodule
