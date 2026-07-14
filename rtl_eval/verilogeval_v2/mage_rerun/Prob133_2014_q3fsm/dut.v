module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic s,
    input  logic w,
    output logic z
);

    // State encoding
    localparam [2:0] A     = 3'd0;
    localparam [2:0] B     = 3'd1; // fresh window start, 0 samples, z=0
    localparam [2:0] C1_0  = 3'd2; // 1 sample taken, count=0
    localparam [2:0] C1_1  = 3'd3; // 1 sample taken, count=1
    localparam [2:0] C2_0  = 3'd4; // 2 samples taken, count=0
    localparam [2:0] C2_1  = 3'd5; // 2 samples taken, count=1
    localparam [2:0] C2_2  = 3'd6; // 2 samples taken, count=2
    localparam [2:0] ZTWO  = 3'd7; // 3 samples taken, count==2, z=1

    logic [2:0] state, state_next;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= state_next;
    end

    // Next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            A: begin
                state_next = (s) ? B : A;
            end
            B: begin
                state_next = (w) ? C1_1 : C1_0;
            end
            C1_0: begin
                state_next = (w) ? C2_1 : C2_0;
            end
            C1_1: begin
                state_next = (w) ? C2_2 : C2_1;
            end
            C2_0: begin
                state_next = B; // total count 0 or 1, either way not 2
            end
            C2_1: begin
                state_next = (w) ? ZTWO : B; // total count 2 or 1
            end
            C2_2: begin
                state_next = (w) ? B : ZTWO; // total count 3 or 2
            end
            ZTWO: begin
                state_next = (w) ? C1_1 : C1_0;
            end
            default: begin
                state_next = A;
            end
        endcase
    end

    // Output combinational logic (Moore)
    always @(*) begin
        z = (state == ZTWO) ? 1'b1 : 1'b0;
    end

endmodule