// ============================================================================
// Module: TopModule
// Purpose: Sign-extend an 8-bit input to a 32-bit output.
//          Implements all scenarios from the "8-bit to 32-bit Sign Extension"
//          feature specification using pure combinational logic.
// ============================================================================
module TopModule (
    input  [7:0]  in,
    output [31:0] out
);

    // Scenario: Lower 8 bits of output always equal the input
    //   -> out[7:0] = in
    // Scenario: Upper 24 bits equal replicated sign bit for any input
    //   -> out[31:8] = {24{in[7]}}
    // Scenario: Sign extension replicates zero when sign bit is 0
    //   -> when in[7]==0, out[31:8] = 24'b0
    // Scenario: Sign extension replicates one when sign bit is 1
    //   -> when in[7]==1, out[31:8] = 24'hFFFFFF
    // Scenario: Signed integer value is preserved after sign extension
    //   -> replicating the sign bit preserves the two's complement value
    // Scenario: Output equals concatenation of replicated sign bit and input
    //   -> out = {{24{in[7]}}, in}
    assign out = {{24{in[7]}}, in};

endmodule