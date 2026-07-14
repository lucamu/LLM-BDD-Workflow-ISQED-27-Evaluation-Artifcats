module TopModule (
    input  [7:0] in_A,
    input  [7:0] in_B,
    input  [1:0] in_operation,
    output [7:0] out_c
);

    // -----------------------------------------------------------
    // Internal wires
    // -----------------------------------------------------------
    wire [7:0] and_result;      // A AND B
    wire [7:0] or_result;       // A OR  B
    wire [7:0] logic_result;    // Selected AND/OR result (OP[0] selects)
    wire [7:0] b_for_adder;     // B operand fed to adder (inverted for SUB)
    wire [7:0] arith_result;    // ADD/SUB result from adder
    wire [7:0] final_result;    // Final ALU output (OP[1] selects domain)

    // -----------------------------------------------------------
    // @and_operation / @or_operation :
    // Bitwise AND and OR sub-results computed unconditionally.
    // -----------------------------------------------------------
    bit_8_AND u_and (
        .A    (in_A),
        .B    (in_B),
        .aANDb(and_result)
    );

    bit_8_OR u_or (
        .A   (in_A),
        .B   (in_B),
        .aORb(or_result)
    );

    // -----------------------------------------------------------
    // @opcode_low_bit_selects_function (logic domain):
    // OP[0] = 0 -> AND, OP[0] = 1 -> OR
    // -----------------------------------------------------------
    mux_2X1 u_mux_logic (
        .O   (logic_result),
        .I0  (and_result),   // OP[0] = 0 : AND
        .I1  (or_result),    // OP[0] = 1 : OR
        .sel (in_operation[0])
    );

    // -----------------------------------------------------------
    // @adder_carry_in_consistency :
    // For SUB (OP[0]=1) perform two's-complement subtraction:
    //   A - B = A + (~B) + 1
    // carry_in is tied directly to OP[0].
    // -----------------------------------------------------------
    assign b_for_adder = in_B ^ {8{in_operation[0]}}; // invert B for subtract

    bit_8_ADDER u_adder (
        .aPlusb  (arith_result),
        .A       (in_A),
        .B       (b_for_adder),
        .carry_in(in_operation[0])
    );

    // arith_result now equals:
    //   OP[0]=0 : A + B         (@add_operation)
    //   OP[0]=1 : A + ~B + 1 = A - B (mod 256) (@sub_operation)

    // -----------------------------------------------------------
    // @mux_selection_consistency / @opcode_high_bit_selects_domain:
    // Final mux selects between logic_result and arith_result
    // based on OP[1].
    // -----------------------------------------------------------
    mux_2X1 u_mux_final (
        .O   (final_result),
        .I0  (logic_result),   // OP[1] = 0 : logic domain
        .I1  (arith_result),   // OP[1] = 1 : arithmetic domain
        .sel (in_operation[1])
    );

    // -----------------------------------------------------------
    // @output_combinational_no_state / @no_x_propagation:
    // Pure combinational assignment - output depends only on
    // current inputs, always fully defined.
    // -----------------------------------------------------------
    assign out_c = final_result;

endmodule

module bit_8_AND(aANDb,A,B);
	output reg [7:0] aANDb;
	input [7:0]A,B;
	always @(*)
		begin
			aANDb <= A&B;
		end
endmodule

module bit_8_OR(
	output reg [7:0]aORb,
	input [7:0]A,
	input [7:0]B
);
	always @(*)
		begin
			aORb <= A|B;
		end
endmodule

module bit_8_ADDER(
	output reg [7:0]aPlusb,
	input [7:0]A,
	input [7:0]B,
	input carry_in);
	reg [7:0]BB;
	always @(*)
		begin
			if(carry_in == 1)
				BB <= ~B;
			else
				BB <= B;
         aPlusb <= A + BB;            
		end
endmodule

module mux_2X1(
	output reg [7:0]O,
	input [7:0]I0,
	input [7:0]I1,
	input sel);

	always @(*)
		begin
			if(sel == 0)
				O <= I0;
			else
				O <= I1;
		end
endmodule
