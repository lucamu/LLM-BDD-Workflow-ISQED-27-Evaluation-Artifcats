//------------------------------------------------------------------------
// Module: TopModule
// Purpose: Moore-type FSM with 5 valid states (000,001,010,011,100),
//          synchronous active-high reset, single-bit input x, output z.
//------------------------------------------------------------------------
module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // Internal state register - 3 bits, as specified
    reg [2:0] y;

    // State encodings
    localparam S000 = 3'b000;
    localparam S001 = 3'b001;
    localparam S010 = 3'b010;
    localparam S011 = 3'b011;
    localparam S100 = 3'b100;

    //--------------------------------------------------------------------
    // Sequential state transition logic
    // Scenarios: @reset, @transition (state000..state100), @invariant
    //--------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            // @reset: Synchronous reset forces state to 000
            y <= S000;
        end else begin
            case (y)
                // @transition @state000
                S000: y <= x ? S001 : S000;

                // @transition @state001
                S001: y <= x ? S100 : S001;

                // @transition @state010
                S010: y <= x ? S001 : S010;

                // @transition @state011
                S011: y <= x ? S010 : S001;

                // @transition @state100
                S100: y <= x ? S100 : S011;

                // Default case to avoid latches / handle invalid states
                default: y <= S000;
            endcase
        end
    end

    //--------------------------------------------------------------------
    // Moore output logic - depends only on current state
    // Scenarios: @output (state000..state100), @invariant (output depends
    // only on current state), reset scenario (output 0 after reset since
    // state becomes 000)
    //--------------------------------------------------------------------
    assign z = (y == S011) || (y == S100);

endmodule