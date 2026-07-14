// =============================================================================
// Module: TopModule
// Purpose: Combinational Keyboard Scancode Decoder for Keys 0-9
//          Decodes 8-bit keyboard scancodes into 4-bit key values (0-9).
//          Asserts 'valid' when scancode is recognized; otherwise out=0, valid=0.
// =============================================================================
module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    reg [3:0] out_r;
    reg       valid_r;

    always @(*) begin
        // Default assignments to avoid latches
        out_r   = 4'd0;
        valid_r = 1'b0;

        case (code)
            // @scancode_decode @key0 : 8'h45 -> 0
            8'h45: begin
                out_r   = 4'd0;
                valid_r = 1'b1;
            end
            // @scancode_decode @key1 : 8'h16 -> 1
            8'h16: begin
                out_r   = 4'd1;
                valid_r = 1'b1;
            end
            // @scancode_decode @key2 : 8'h1e -> 2
            8'h1e: begin
                out_r   = 4'd2;
                valid_r = 1'b1;
            end
            // @scancode_decode @key3 : 8'h26 -> 3
            8'h26: begin
                out_r   = 4'd3;
                valid_r = 1'b1;
            end
            // @scancode_decode @key4 : 8'h25 -> 4
            8'h25: begin
                out_r   = 4'd4;
                valid_r = 1'b1;
            end
            // @scancode_decode @key5 : 8'h2e -> 5
            8'h2e: begin
                out_r   = 4'd5;
                valid_r = 1'b1;
            end
            // @scancode_decode @key6 : 8'h36 -> 6
            8'h36: begin
                out_r   = 4'd6;
                valid_r = 1'b1;
            end
            // @scancode_decode @key7 : 8'h3d -> 7
            8'h3d: begin
                out_r   = 4'd7;
                valid_r = 1'b1;
            end
            // @scancode_decode @key8 : 8'h3e -> 8
            8'h3e: begin
                out_r   = 4'd8;
                valid_r = 1'b1;
            end
            // @scancode_decode @key9 : 8'h46 -> 9
            8'h46: begin
                out_r   = 4'd9;
                valid_r = 1'b1;
            end
            // @invalid_scancode : any unrecognized code -> out=0, valid=0
            default: begin
                out_r   = 4'd0;
                valid_r = 1'b0;
            end
        endcase
    end

    // Continuous assignment to outputs
    // @mutual_exclusivity, @output_range, @deterministic_mapping satisfied
    // by the unique case decoding above (each recognized code maps to a
    // distinct out value 0-9, and valid is asserted iff exactly one case matches).
    assign out   = out_r;
    assign valid = valid_r;

endmodule