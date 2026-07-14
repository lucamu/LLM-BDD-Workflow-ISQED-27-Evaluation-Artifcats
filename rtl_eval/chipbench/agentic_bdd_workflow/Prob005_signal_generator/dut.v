// =============================================================================
// Module: TopModule
// Purpose: Waveform Generator producing square, sawtooth, or triangular
//          waveforms on a 5-bit output `wave`, selected via `wave_choice`.
//          Synchronous design, active-low synchronous reset.
// =============================================================================
module TopModule (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] wave_choice,
    output reg  [4:0] wave
);

    // Direction state for triangular wave: 1 = up (counting up), 0 = down
    reg dir;

    // Local parameters for wave_choice decoding
    localparam WAVE_SQUARE    = 2'b00;
    localparam WAVE_SAWTOOTH  = 2'b01;
    localparam WAVE_TRIANGLE  = 2'b10;

    localparam MAX_VAL = 5'b11111;
    localparam MIN_VAL = 5'b00000;

    always @(posedge clk) begin
        if (!rst_n) begin
            // @reset: wave forced to initial value 0
            wave <= MIN_VAL;
            // @reset @direction: dir initialized to up
            dir  <= 1'b1;
        end else begin
            case (wave_choice)

                // ---------------------------------------------------------
                // @square: Square wave toggles between min and max
                // ---------------------------------------------------------
                WAVE_SQUARE: begin
                    if (wave == MIN_VAL)
                        wave <= MAX_VAL; // toggles min -> max
                    else
                        wave <= MIN_VAL; // toggles max (or any nonzero) -> min
                    // dir is not used in square mode but keep it stable
                    dir <= dir;
                end

                // ---------------------------------------------------------
                // @sawtooth: Increments until max, then wraps to zero
                // ---------------------------------------------------------
                WAVE_SAWTOOTH: begin
                    if (wave < MAX_VAL)
                        wave <= wave + 5'b00001; // increment while below max
                    else
                        wave <= MIN_VAL;         // wrap to zero at max
                    dir <= dir; // unused in sawtooth mode, keep stable
                end

                // ---------------------------------------------------------
                // @triangular: Ascends/descends based on dir state
                // ---------------------------------------------------------
                WAVE_TRIANGLE: begin
                    if (dir) begin
                        // Currently counting up
                        if (wave < MAX_VAL) begin
                            // @ascending: increment, dir remains up
                            wave <= wave + 5'b00001;
                            dir  <= 1'b1;
                        end else begin
                            // @peak: at max, switch to counting down
                            wave <= wave - 5'b00001;
                            dir  <= 1'b0;
                        end
                    end else begin
                        // Currently counting down
                        if (wave > MIN_VAL) begin
                            // @descending: decrement, dir remains down
                            wave <= wave - 5'b00001;
                            dir  <= 1'b0;
                        end else begin
                            // @trough: at min, switch to counting up
                            wave <= wave + 5'b00001;
                            dir  <= 1'b1;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Default case: hold current values (avoids latch, safe default)
                // ---------------------------------------------------------
                default: begin
                    wave <= wave;
                    dir  <= dir;
                end

            endcase
        end
    end

    // @mode_switch: wave is a registered output, so changes to wave_choice
    // combinationally do not affect wave until the next clock edge.
    // This is inherently satisfied by the synchronous always block above.

endmodule