// Module: TopModule
// Purpose: Cellphone Ringer and Vibration Motor Control
// Combinational logic that drives exactly one of ringer/motor when
// ring is asserted, chosen by vibrate_mode. Both outputs are 0 when
// ring is deasserted.
module TopModule (
    input  ring,
    input  vibrate_mode,
    output ringer,
    output motor
);

    // @no-ring, @ring-normal, @functional-equivalence-ringer,
    // @no-spurious-activation, @mutual-exclusion, @exactly-one-when-ringing
    // ringer active only when ringing and NOT in vibrate mode
    assign ringer = ring & ~vibrate_mode;

    // @no-ring, @ring-vibrate, @functional-equivalence-motor,
    // @no-spurious-activation, @mutual-exclusion, @exactly-one-when-ringing
    // motor active only when ringing and vibrate mode is set
    assign motor = ring & vibrate_mode;

endmodule