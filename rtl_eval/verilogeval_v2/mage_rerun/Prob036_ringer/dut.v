module TopModule (
    input  logic ring,
    input  logic vibrate_mode,
    output logic ringer,
    output logic motor
);

    assign motor  = ring & vibrate_mode;
    assign ringer = ring & ~vibrate_mode;

endmodule