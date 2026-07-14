// ============================================================================
// Module: TopModule
// Purpose: 8-bit Priority Encoder
//   Combinationally reports the index of the least significant '1' bit
//   in an 8-bit input vector. Outputs zero if no bits are set.
// ============================================================================
module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    // Combinational priority encoder logic
    // Priority given to lowest-index set bit (LSB priority)
    always @(*) begin
        // Default case: covers all-zero input scenario (@zero_input)
        // Also ensures no latch inference (full assignment in all branches)
        if (in[0])
            pos = 3'd0; // @bit0_priority: bit 0 set -> highest priority
        else if (in[1])
            pos = 3'd1; // @bit_i_lowest_set: bit 1 is lowest set bit
        else if (in[2])
            pos = 3'd2; // lowest set bit at index 2
        else if (in[3])
            pos = 3'd3; // lowest set bit at index 3
        else if (in[4])
            pos = 3'd4; // lowest set bit at index 4
        else if (in[5])
            pos = 3'd5; // lowest set bit at index 5
        else if (in[6])
            pos = 3'd6; // lowest set bit at index 6
        else if (in[7])
            pos = 3'd7; // @highest_bit: only bit 7 set -> output 7
        else
            pos = 3'd0; // @zero_input: no bits set -> output 0
    end

endmodule