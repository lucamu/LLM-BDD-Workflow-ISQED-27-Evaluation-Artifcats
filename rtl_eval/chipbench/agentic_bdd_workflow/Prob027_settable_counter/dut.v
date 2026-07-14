// ============================================================================
// Module: TopModule
// Purpose: 4-bit hexadecimal counter with synchronous set and asynchronous
//          active-low reset. Provides a 'zero' flag indicating when the
//          counter value is 4'h0.
// ============================================================================
module TopModule (
    input        clk,
    input        rst_n,
    input        set,
    input  [3:0] set_num,
    output [3:0] number,
    output       zero
);

    reg [3:0] number_reg;

    // Sequential logic: handles reset, set, and count scenarios
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: Asynchronous reset forces counter to zero
            // @reset: Reset takes priority over set
            number_reg <= 4'h0;
        end else if (set) begin
            // @set: Set operation loads set_num into number
            number_reg <= set_num;
        end else begin
            // @count: Counter increments by one when set is inactive
            // @count: Counter wraps from F to 0 (natural wraparound of 4-bit add)
            number_reg <= number_reg + 4'h1;
        end
    end

    // Combinational output assignment
    assign number = number_reg;

    // @zero: Zero output is combinationally consistent with number
    // (also covers zero flag after set and after count, since it derives
    //  directly from the registered number_reg value)
    assign zero = (number_reg == 4'h0);

endmodule