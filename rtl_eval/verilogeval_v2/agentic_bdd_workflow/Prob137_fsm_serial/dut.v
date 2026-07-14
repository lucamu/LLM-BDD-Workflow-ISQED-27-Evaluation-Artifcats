//==============================================================================
// Module: TopModule
// Purpose: Serial UART Byte Framing Detector (Start-Data-Stop FSM)
//          Monitors serial line 'in' for a valid frame: 1 start bit (0),
//          8 data bits (LSB first, any value), 1 stop bit (1). Asserts
//          'done' for exactly one clock cycle when a correctly framed byte
//          is received. On stop bit error, resyncs by waiting for line=1.
//==============================================================================
module TopModule (
    input  wire clk,
    input  wire in,
    input  wire reset,
    output reg  done
);

    // FSM state encoding
    localparam IDLE   = 2'b00; // waiting for start bit (line=1 idle)
    localparam DATA   = 2'b01; // receiving 8 data bits
    localparam STOP   = 2'b10; // checking stop bit
    localparam RESYNC = 2'b11; // waiting for line=1 after framing error

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt, next_bit_cnt; // counts 0..7 for the 8 data bits

    //--------------------------------------------------------------------
    // Sequential state/counter update
    //--------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset scenarios: synchronous reset forces idle state, done=0
            state   <= IDLE;
            bit_cnt <= 3'd0;
        end else begin
            state   <= next_state;
            bit_cnt <= next_bit_cnt;
        end
    end

    //--------------------------------------------------------------------
    // Combinational next-state logic
    //--------------------------------------------------------------------
    always @(*) begin
        // default: hold current values
        next_state   = state;
        next_bit_cnt = bit_cnt;

        case (state)
            IDLE: begin
                // @idle: line held at 1 -> stay idle, done stays 0
                // @start: detect start bit (in==0) -> move to DATA
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
                next_bit_cnt = 3'd0;
            end

            DATA: begin
                // @data: count 8 data bits regardless of value
                if (bit_cnt == 3'd7) begin
                    // all 8 data bits received, move to check stop bit
                    next_state   = STOP;
                    next_bit_cnt = 3'd0;
                end else begin
                    next_state   = DATA;
                    next_bit_cnt = bit_cnt + 3'd1;
                end
            end

            STOP: begin
                // @stop_correct: in==1 -> valid frame, return to IDLE
                // @stop_incorrect: in==0 -> framing error, enter RESYNC
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RESYNC;
                next_bit_cnt = 3'd0;
            end

            RESYNC: begin
                // @resync: wait while in==0, exit to IDLE when in==1
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RESYNC;
                next_bit_cnt = 3'd0;
            end

            default: begin
                // safety default to avoid latches / unknown states
                next_state   = IDLE;
                next_bit_cnt = 3'd0;
            end
        endcase
    end

    //--------------------------------------------------------------------
    // Registered 'done' output: asserted for exactly one cycle
    // when a correctly framed stop bit (in==1) is seen in STOP state.
    //--------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset: done forced low on reset
            done <= 1'b0;
        end else begin
            // done pulses only during STOP state with correct stop bit
            if (state == STOP && in == 1'b1)
                done <= 1'b1; // @stop_correct / @full_frame / @back_to_back
            else
                done <= 1'b0; // all other cases: idle, data, incorrect stop, resync
        end
    end

endmodule