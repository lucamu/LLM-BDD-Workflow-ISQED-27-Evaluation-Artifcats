module TopModule (
    input  logic [3:0] A_in,
    input  logic [3:0] B_in,
    input  logic C_1,
    output logic [3:0] S,
    output logic CO
);

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    // Generate and Propagate signals for each bit
    and (G[0], A_in[0], B_in[0]);
    and (G[1], A_in[1], B_in[1]);
    and (G[2], A_in[2], B_in[2]);
    and (G[3], A_in[3], B_in[3]);

    xor (P[0], A_in[0], B_in[0]);
    xor (P[1], A_in[1], B_in[1]);
    xor (P[2], A_in[2], B_in[2]);
    xor (P[3], A_in[3], B_in[3]);

    // Carry chain: C[i] is carry out of bit i
    wire pc0, pc1, pc2, pc3;

    and (pc0, P[0], C_1);
    or  (C[0], G[0], pc0);

    and (pc1, P[1], C[0]);
    or  (C[1], G[1], pc1);

    and (pc2, P[2], C[1]);
    or  (C[2], G[2], pc2);

    and (pc3, P[3], C[2]);
    or  (C[3], G[3], pc3);

    // Sum outputs
    xor (S[0], P[0], C_1);
    xor (S[1], P[1], C[0]);
    xor (S[2], P[2], C[1]);
    xor (S[3], P[3], C[2]);

    // Final carry out
    buf (CO, C[3]);

endmodule