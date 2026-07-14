//==============================================================================
// Module: TopModule
// Purpose: 8-bit shift register that shifts in serial input 'a' and asserts
//          'match' whenever the register equals pattern 8'b0111_0001
//==============================================================================
module TopModule (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire match
);

    // Internal 8-bit shift register
    reg [7:0] a_tem;

    // Target pattern to match against
    localparam [7:0] PATTERN = 8'b0111_0001;

    //--------------------------------------------------------------------
    // Sequential logic: shift register with synchronous active-low reset
    //--------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            // Scenario: Reset clears the shift register and de-asserts match
            // Scenario: Reset holds shift register and match low regardless of a
            a_tem <= 8'b0000_0000;
        end else begin
            // Scenario: Shift register shifts left and inserts input a at LSB
            // Scenario: Shift register retains only the 8 most recent bits of a
            // Scenario: After reset de-assertion, shift register evolves only
            //           from shifted-in input
            a_tem <= {a_tem[6:0], a};
        end
    end

    //--------------------------------------------------------------------
    // Combinational logic: match output is a pure function of a_tem
    //--------------------------------------------------------------------
    // Scenario: Match asserts when shift register equals target pattern
    // Scenario: Match de-asserts when shift register does not equal pattern
    // Scenario: Match output is a pure function of the shift register value
    assign match = (a_tem == PATTERN) ? 1'b1 : 1'b0;

endmodule