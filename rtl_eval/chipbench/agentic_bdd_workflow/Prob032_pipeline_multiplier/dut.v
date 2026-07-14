// =============================================================================
// Module: TopModule
// Purpose: 4-bit x 4-bit unsigned pipelined multiplier with 2-cycle latency.
//          Inputs are captured into a pipeline register on cycle 1 (stage 0),
//          the product is computed and registered on cycle 2 (stage 1),
//          producing mul_out exactly 2 clock cycles after inputs are applied.
//          Asynchronous active-low reset clears both pipeline stages immediately.
// =============================================================================
module TopModule #(
    parameter size = 4
) (
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output     [size*2-1:0]   mul_out
);

    // -------------------------------------------------------------------
    // Stage 0 registers: capture operands on each clock edge (throughput
    // scenario - new inputs accepted every cycle without stalling)
    // -------------------------------------------------------------------
    reg [size-1:0] a_stage0;
    reg [size-1:0] b_stage0;

    // -------------------------------------------------------------------
    // Stage 1 register: registered product output (pipeline latency /
    // ordering scenarios - result of stage0 operands appears here)
    // -------------------------------------------------------------------
    reg [size*2-1:0] product_stage1;

    // -------------------------------------------------------------------
    // Sequential logic with asynchronous active-low reset.
    // Scenario: Asynchronous reset forces output to zero immediately.
    // Scenario: Output remains zero while reset is held low.
    // Scenario: Reset asserted mid-pipeline clears in-flight results.
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear both pipeline stages immediately
            a_stage0       <= {size{1'b0}};
            b_stage0       <= {size{1'b0}};
            product_stage1 <= {(size*2){1'b0}};
        end else begin
            // Stage 0: capture new operands every cycle (throughput scenario)
            a_stage0 <= mul_a;
            b_stage0 <= mul_b;

            // Stage 1: compute product from previously captured operands
            // (latency scenario: result appears 2 cycles after input capture;
            //  ordering scenario: back-to-back inputs preserve FIFO order;
            //  boundary scenarios: zero operand -> zero product,
            //  max operands 4'b1111 * 4'b1111 = 8'd225)
            product_stage1 <= a_stage0 * b_stage0;
        end
    end

    // -------------------------------------------------------------------
    // Output assignment: registered product from stage 1
    // Satisfies functional/range scenario: mul_out <= 8'd225 always,
    // since max 4-bit * 4-bit product is 15*15 = 225.
    // -------------------------------------------------------------------
    assign mul_out = product_stage1;

endmodule