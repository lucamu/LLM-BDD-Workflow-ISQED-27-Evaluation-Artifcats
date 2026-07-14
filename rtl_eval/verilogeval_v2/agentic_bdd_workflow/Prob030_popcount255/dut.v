// ============================================================================
// Module: TopModule
// Purpose: 255-bit Population Count Circuit
//   Computes the number of '1' bits in a 255-bit input vector and outputs
//   the result as an 8-bit count (0 to 255).
//
// Scenario coverage:
//   @zero        : in=0            -> out=0        (handled by sum logic)
//   @allones     : in=all 1s       -> out=255       (handled by sum logic)
//   @singlebit   : single bit set  -> out=1         (handled by sum logic)
//   @range       : out is 8 bits, naturally 0..255  (handled by width)
//   @correctness : out = sum of bits of in          (core implementation)
//   @complement  : out(in) + out(~in) = 255         (arithmetic property,
//                  holds automatically since every bit contributes exactly
//                  1 to exactly one of the two counts)
//   @incremental/@clearing/@monotonic : follow directly from bit-sum
//                  definition, no extra logic needed
//   @nostate     : purely combinational (assign), no memory elements
// ============================================================================

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Combinational population count.
    // Sum all 255 bits of 'in' into an 8-bit accumulator using blocking
    // assignments inside a combinational always block (no clock/reset).
    reg [7:0] count;
    integer i;

    always @(*) begin
        count = 8'd0;                     // start count at zero (@zero scenario baseline)
        for (i = 0; i < 255; i = i + 1) begin
            count = count + in[i];         // add each bit: contributes 0 or 1 (@correctness)
        end
    end

    // Drive output - purely combinational, no dependency on previous state (@nostate)
    assign out = count;

endmodule