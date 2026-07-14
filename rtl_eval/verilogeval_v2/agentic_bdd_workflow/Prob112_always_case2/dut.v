// ============================================================================
// Module: TopModule
// Purpose: 4-bit Priority Encoder
//          Outputs the bit-position of the least-significant set bit in the
//          4-bit input vector `in`. If no bits are set, outputs zero.
//          Purely combinational, no clock/reset.
// ============================================================================
module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        // @bit0_priority: in[0]==1 has highest priority -> pos = 0
        if (in[0])
            pos = 2'd0;
        // @bit1_priority: in[0]==0, in[1]==1 -> pos = 1
        else if (in[1])
            pos = 2'd1;
        // @bit2_priority: in[1:0]==2'b00, in[2]==1 -> pos = 2
        else if (in[2])
            pos = 2'd2;
        // @bit3_priority: in[2:0]==3'b000, in[3]==1 -> pos = 3
        else if (in[3])
            pos = 2'd3;
        // @all_zero: in == 4'b0000 -> pos = 0
        else
            pos = 2'd0;
    end

    // @general_priority_function: covered by the priority if/else chain above
    // @output_range: pos is a 2-bit reg, inherently bounded to 0-3

endmodule