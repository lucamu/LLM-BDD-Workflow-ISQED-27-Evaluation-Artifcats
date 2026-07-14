//==============================================================================
// Module: TopModule
// Purpose: 4-bit BCD (0-9) up/down counter with active-low async reset and
//          registered zero-detection flag (asserted one cycle after number==0)
//==============================================================================
module TopModule (
    input        clk,
    input        rst_n,
    input        mode,
    output [3:0] number,
    output       zero
);

    reg [3:0] number_r;
    reg       zero_r;

    assign number = number_r;
    assign zero   = zero_r;

    //--------------------------------------------------------------------
    // Sequential logic: counter update and zero flag registration
    //--------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset @async: Asynchronous reset forces counter and zero to 0
            // regardless of mode value
            number_r <= 4'b0000;
            zero_r   <= 1'b0;
        end else begin
            // Counter update logic
            if (mode) begin
                // @count_up: mode == 1
                if (number_r == 4'd9)
                    // @count_up @wraparound: 9 -> 0
                    number_r <= 4'd0;
                else
                    // @count_up @increment: N -> N+1
                    number_r <= number_r + 4'd1;
            end else begin
                // @count_down: mode == 0
                if (number_r == 4'd0)
                    // @count_down @wraparound: 0 -> 9
                    number_r <= 4'd9;
                else
                    // @count_down @decrement: N -> N-1
                    number_r <= number_r - 4'd1;
            end

            // @zero_flag @registered: zero reflects previous cycle's number
            // @zero_flag @assertion / @deassertion
            if (number_r == 4'd0)
                zero_r <= 1'b1;
            else
                zero_r <= 1'b0;
        end
    end

    // @range @invariant: number_r is always kept within 0-9 by the
    // wraparound logic above, satisfying the range invariant.
    // @stability: without a clock edge, number_r retains its value since
    // it is only updated inside the clocked always block.

endmodule