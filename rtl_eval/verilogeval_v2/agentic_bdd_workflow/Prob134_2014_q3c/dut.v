// Purpose: Combinational FSM next-state and output logic.
//          Present state is given by input y[2:0]; next state is computed
//          combinationally from y and x. Y0 = next_state[0]; z is a
//          combinational function of the present state y only.
//          clk is present on the interface but has NO effect on Y0 or z,
//          since both are purely combinational (see @clk_irrelevance).
// =============================================================================
module TopModule (
    input        clk,   // Present on interface but unused in combinational logic
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       z_reg;

    // -------------------------------------------------------------------
    // Combinational next-state logic based on present state y and input x
    // Implements scenarios @state_000, @state_001, @state_010,
    // @state_011, @state_100
    // -------------------------------------------------------------------
    always @(*) begin
        case (y)
            3'b000: begin
                // @state_000: 000 --x=0--> 000, --x=1--> 001
                if (x == 1'b0)
                    next_state = 3'b000;
                else
                    next_state = 3'b001;
            end
            3'b001: begin
                // @state_001: 001 --x=0--> 001, --x=1--> 100
                if (x == 1'b0)
                    next_state = 3'b001;
                else
                    next_state = 3'b100;
            end
            3'b010: begin
                // @state_010: 010 --x=0--> 010, --x=1--> 001
                if (x == 1'b0)
                    next_state = 3'b010;
                else
                    next_state = 3'b001;
            end
            3'b011: begin
                // @state_011: 011 --x=0--> 001, --x=1--> 010
                if (x == 1'b0)
                    next_state = 3'b001;
                else
                    next_state = 3'b010;
            end
            3'b100: begin
                // @state_100: 100 --x=0--> 011, --x=1--> 100
                if (x == 1'b0)
                    next_state = 3'b011;
                else
                    next_state = 3'b100;
            end
            default: begin
                // Undefined/unused states: safe default to avoid latches
                next_state = 3'b000;
            end
        endcase
    end

    // -------------------------------------------------------------------
    // Combinational output z depends only on present state y
    // Implements @z_only_depends_on_present_state and per-state z values
    // in @state_000 .. @state_100
    // -------------------------------------------------------------------
    always @(*) begin
        case (y)
            3'b000: z_reg = 1'b0; // @state_000: z = 0
            3'b001: z_reg = 1'b0; // @state_001: z = 0
            3'b010: z_reg = 1'b0; // @state_010: z = 0
            3'b011: z_reg = 1'b1; // @state_011: z = 1
            3'b100: z_reg = 1'b1; // @state_100: z = 1
            default: z_reg = 1'b0; // Safe default for undefined states
        endcase
    end

    // -------------------------------------------------------------------
    // Output assignments
    // @Y0_consistency: Y0 always equals bit 0 of the computed next state
    // clk is intentionally not part of any sensitivity list (@clk_irrelevance)
    // -------------------------------------------------------------------
    assign Y0 = next_state[0];
    assign z  = z_reg;

endmodule