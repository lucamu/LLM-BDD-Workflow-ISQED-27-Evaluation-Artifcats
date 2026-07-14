module TopModule(
    input  logic [7:0] in_A,
    input  logic [7:0] in_B,
    input  logic [1:0] in_operation,
    output logic [7:0] out_c
);

    logic [7:0] and_result;
    logic [7:0] or_result;
    logic [7:0] add_sub_result;
    logic [7:0] logic_mux_result;

    bit_8_AND u_and (
        .aANDb(and_result),
        .A(in_A),
        .B(in_B)
    );

    bit_8_OR u_or (
        .aORb(or_result),
        .A(in_A),
        .B(in_B)
    );

    bit_8_ADDER u_adder (
        .aPlusb(add_sub_result),
        .A(in_A),
        .B(in_B),
        .carry_in(in_operation[0])
    );

    mux_2X1 u_logic_mux (
        .O(logic_mux_result),
        .I0(and_result),
        .I1(or_result),
        .sel(in_operation[0])
    );

    mux_2X1 u_final_mux (
        .O(out_c),
        .I0(logic_mux_result),
        .I1(add_sub_result),
        .sel(in_operation[1])
    );

endmodule

//AND
module bit_8_AND(aANDb,A,B);
	output reg [7:0] aANDb;
	input [7:0]A,B;
	always @(*)
		begin
			aANDb <= A&B;
		end
endmodule

//OR
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

//8 bit adder
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

//2 X 1 multiplxer
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