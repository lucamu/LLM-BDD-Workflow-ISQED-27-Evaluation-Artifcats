module TopModule (
    input        clk,
    input        rst_n,
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    output [7:0] d
);

    // -----------------------------------------------------------
    // Internal wires connecting the hierarchical Min2 comparators
    // -----------------------------------------------------------
    wire [7:0] min_ab;    // minimum of a and b (stage 1)
    wire [7:0] min_abc;   // minimum of min_ab and c (stage 2, overall min)

    // Active-high reset signal for dut__Min2 submodules (they expect "rst")
    wire rst_active_high = ~rst_n;

    // -----------------------------------------------------------
    // Stage 1: Compare a and b
    // @submodule @comparator, @submodule @comparator @tie
    // -----------------------------------------------------------
    dut__Min2 u_min_ab (
        .clk      (clk),
        .rst      (rst_active_high),
        .data_a   (a),
        .data_b   (b),
        .data_min (min_ab)
    );

    // -----------------------------------------------------------
    // Stage 2: Compare the result of stage 1 with c
    // Produces the overall minimum of a, b, c
    // -----------------------------------------------------------
    dut__Min2 u_min_abc (
        .clk      (clk),
        .rst      (rst_active_high),
        .data_a   (min_ab),
        .data_b   (c),
        .data_min (min_abc)
    );

    // -----------------------------------------------------------
    // Registered output stage
    // @reset @asynchronous : rst_n=0 forces d to 0 immediately
    // @reset @recovery     : after rst_n release, d follows min(a,b,c)
    // @functional @minimum, @equal_values, @two_equal_minimum,
    // @boundary             : d equals the correct minimum value
    // @structural @invariant: d is always one of a,b,c and <= all inputs
    // -----------------------------------------------------------
    reg [7:0] d_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: force output to zero immediately
            d_reg <= 8'b0000_0000;
        end else begin
            // Normal operation: capture the computed minimum
            d_reg <= min_abc;
        end
    end

    assign d = d_reg;

endmodule

module dut__Min2 (
    input        clk,        // Clock (registered output only, no functional effect on min logic)
    input        rst,        // Synchronous reset (initializes register only)
    input  [7:0] data_a,     // 8-bit unsigned input A
    input  [7:0] data_b,     // 8-bit unsigned input B
    output reg [7:0] data_min // 8-bit unsigned minimum output (registered)
);

    // -------------------------------------------------------------------
    // Combinational core comparator logic
    // Scenario: Output equals data_a when data_a <= data_b
    // Scenario: Output equals data_b when data_a > data_b
    // Scenario: Output equals both inputs when they are equal (A<=B path)
    // Scenario: Output always equals the minimum of the two inputs
    // Scenario: Output never exceeds either input
    // Scenario: Output always equals one of the two inputs
    // Scenario: Boundary correctness at 0/255 values
    // -------------------------------------------------------------------
    reg [7:0] min_comb;

    always @(*) begin
        if (data_a <= data_b) begin
            // A <= B: minimum is A (covers equality case as well)
            min_comb = data_a;
        end else begin
            // A > B: minimum is B
            min_comb = data_b;
        end
    end

    // -------------------------------------------------------------------
    // Registered output stage
    // Scenario: Output is independent of clock and reset (functional value
    //           tracks min(A,B); reset only sets a known initial state and
    //           does not otherwise alter the comparator result once inputs
    //           are stable)
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset: initialize output register only
            data_min <= 8'd0;
        end else begin
            // Normal operation: capture combinational minimum result
            data_min <= min_comb;
        end
    end

endmodule
