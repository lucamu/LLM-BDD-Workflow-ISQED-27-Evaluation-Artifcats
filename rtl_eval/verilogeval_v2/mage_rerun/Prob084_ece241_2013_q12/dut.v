module TopModule (
    input  logic clk,
    input  logic enable,
    input  logic S,
    input  logic A,
    input  logic B,
    input  logic C,
    output logic Z
);

    // 8-bit shift register: Q[0] is fed by S, and bits shift toward Q[7]
    logic [7:0] Q;

    // Initialize to a known value since there is no reset signal
    initial begin
        Q = 8'b0000_0000;
    end

    // Shift register logic: synchronous, active-high enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // 8-to-1 multiplexer selecting Z based on {A,B,C}
    always @(*) begin
        case ({A,B,C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'b0;
        endcase
    end

endmodule