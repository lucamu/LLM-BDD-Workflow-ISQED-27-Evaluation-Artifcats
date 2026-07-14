//=============================================================================
// Module: TopModule
// Purpose: Sequential LCM/GCD calculator using the subtractive Euclidean
//          algorithm.  Implements a simple request/valid handshake:
//            - vld_in with A,B starts a new computation
//            - vld_out pulses/stays high once the result is ready
//            - outputs remain stable until a new request is accepted
//=============================================================================
module TopModule #(
    parameter DATA_W = 8
) (
    input                       clk,
    input                       rst_n,
    input      [DATA_W-1:0]     A,
    input      [DATA_W-1:0]     B,
    input                       vld_in,
    output reg [DATA_W*2-1:0]   lcm_out,
    output reg [DATA_W-1:0]     mcd_out,
    output reg                  vld_out
);

    //-------------------------------------------------------------------
    // FSM state encoding
    //-------------------------------------------------------------------
    localparam IDLE    = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE    = 2'b10;

    reg [1:0] state;

    // Registers holding operands (original for LCM math, working copies
    // for the Euclidean subtraction algorithm)
    reg [DATA_W-1:0] orig_a, orig_b;
    reg [DATA_W-1:0] a_reg,  b_reg;

    //-------------------------------------------------------------------
    // Sequential logic - all outputs and state are registered
    //-------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset: Reset deasserts output valid / holds it low
            state    <= IDLE;
            vld_out  <= 1'b0;
            mcd_out  <= {DATA_W{1'b0}};
            lcm_out  <= {2*DATA_W{1'b0}};
            orig_a   <= {DATA_W{1'b0}};
            orig_b   <= {DATA_W{1'b0}};
            a_reg    <= {DATA_W{1'b0}};
            b_reg    <= {DATA_W{1'b0}};
        end else begin
            case (state)

                //-----------------------------------------------------
                // IDLE: waiting for a new request
                //-----------------------------------------------------
                IDLE: begin
                    if (vld_in) begin
                        // @handshake: valid input eventually produces output
                        orig_a <= A;
                        orig_b <= B;
                        if (A == {DATA_W{1'b0}} || B == {DATA_W{1'b0}}) begin
                            // @edge_case: A==0, B==0, or both==0
                            mcd_out <= (A == {DATA_W{1'b0}}) ? B : A;
                            lcm_out <= {2*DATA_W{1'b0}};
                            vld_out <= 1'b1;
                            state   <= DONE;
                        end else begin
                            a_reg   <= A;
                            b_reg   <= B;
                            vld_out <= 1'b0;
                            state   <= COMPUTE;
                        end
                    end else begin
                        // @handshake: no new computation without vld_in,
                        // outputs stay unchanged
                        vld_out <= vld_out;
                        mcd_out <= mcd_out;
                        lcm_out <= lcm_out;
                        state   <= IDLE;
                    end
                end

                //-----------------------------------------------------
                // COMPUTE: subtractive Euclidean algorithm
                //-----------------------------------------------------
                COMPUTE: begin
                    if (a_reg == b_reg) begin
                        // GCD found (@correctness scenarios)
                        mcd_out <= a_reg;
                        // LCM = (A*B)/GCD, a_reg is guaranteed nonzero here
                        lcm_out <= (orig_a * orig_b) / a_reg;
                        vld_out <= 1'b1;
                        state   <= DONE;
                    end else if (a_reg > b_reg) begin
                        a_reg <= a_reg - b_reg;
                        state <= COMPUTE;
                    end else begin
                        b_reg <= b_reg - a_reg;
                        state <= COMPUTE;
                    end
                end

                //-----------------------------------------------------
                // DONE: result valid, hold until a new request arrives
                //-----------------------------------------------------
                DONE: begin
                    if (vld_in) begin
                        // @liveness: new request clears previous result
                        orig_a <= A;
                        orig_b <= B;
                        if (A == {DATA_W{1'b0}} || B == {DATA_W{1'b0}}) begin
                            mcd_out <= (A == {DATA_W{1'b0}}) ? B : A;
                            lcm_out <= {2*DATA_W{1'b0}};
                            vld_out <= 1'b1; // new result ready immediately
                            state   <= DONE;
                        end else begin
                            a_reg   <= A;
                            b_reg   <= B;
                            vld_out <= 1'b0; // clear valid while recomputing
                            state   <= COMPUTE;
                        end
                    end else begin
                        // @stability: hold outputs and valid while no new req
                        vld_out <= vld_out;
                        mcd_out <= mcd_out;
                        lcm_out <= lcm_out;
                        state   <= DONE;
                    end
                end

                //-----------------------------------------------------
                // Default: safety net, should not be reached
                //-----------------------------------------------------
                default: begin
                    state   <= IDLE;
                    vld_out <= 1'b0;
                end

            endcase
        end
    end

endmodule