//=============================================================================
// Module: TopModule
// Purpose: HDLC Bit Stuffing/Destuffing Frame Boundary Detector
//
// A Moore FSM that scans a serial bit stream and detects:
//   - disc : 5 consecutive ones followed by a 0  (asserted one cycle after
//            the terminating 0 is sampled)
//   - flag : 6 consecutive ones followed by a 0  (asserted one cycle after
//            the terminating 0 is sampled)
//   - err  : 7 or more consecutive ones (asserted one cycle after the 7th
//            one is sampled, and held while ones keep arriving)
//
// State encoding (count of consecutive ones seen so far, plus two special
// "pulse" states that remember a disc/flag was just produced so counting
// of a new run of ones can resume immediately):
//   S0   - 0 consecutive ones (idle)
//   S1..S6 - 1..6 consecutive ones
//   SERR - 7+ consecutive ones (err condition, sticky while ones continue)
//   SD   - one cycle after a disc-triggering 0 (disc pulse state)
//   SF   - one cycle after a flag-triggering 0 (flag pulse state)
//=============================================================================
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding
    localparam [3:0] S0   = 4'd0,
                      S1   = 4'd1,
                      S2   = 4'd2,
                      S3   = 4'd3,
                      S4   = 4'd4,
                      S5   = 4'd5,
                      S6   = 4'd6,
                      SERR = 4'd7,
                      SD   = 4'd8,
                      SF   = 4'd9;

    reg [3:0] state, next_state;

    //-------------------------------------------------------------------
    // Sequential state update
    // @reset @initialization : reset forces idle state S0 (0 consec. ones)
    //-------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    //-------------------------------------------------------------------
    // Combinational next-state logic
    //-------------------------------------------------------------------
    always @(*) begin
        case (state)
            // S0: idle - @leading_zero_no_effect, begin counting on in=1
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            // S1..S4: fewer than 5 consecutive ones so far
            // @no_pattern: a 0 here returns to idle with no special output
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;

            // S5: 5 consecutive ones - @disc scenario
            S5: begin
                if (in)
                    next_state = S6;   // extend run toward flag/err
                else
                    next_state = SD;   // 0 after 5 ones -> disc next cycle
            end

            // S6: 6 consecutive ones - @flag scenario
            S6: begin
                if (in)
                    next_state = SERR; // 7th one -> err condition
                else
                    next_state = SF;   // 0 after 6 ones -> flag next cycle
            end

            // SERR: 7+ consecutive ones
            // @err_persists : stays while in=1
            // @err_terminates : 0 clears err, returns to idle
            SERR: begin
                if (in)
                    next_state = SERR;
                else
                    next_state = S0;
            end

            // SD: disc pulse state - @single_cycle_pulse_disc,
            // @disc_resumes_counting : new run of ones counted from here
            SD: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            // SF: flag pulse state - @single_cycle_pulse_flag,
            // @flag_resumes_counting : new run of ones counted from here
            SF: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            default: next_state = S0; // safety default, avoid latches
        endcase
    end

    //-------------------------------------------------------------------
    // Moore outputs - depend only on current (registered) state
    // @mutual_exclusion : exactly one (or none) of these states is active,
    // so disc, flag, err are naturally mutually exclusive
    //-------------------------------------------------------------------
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SERR);

endmodule