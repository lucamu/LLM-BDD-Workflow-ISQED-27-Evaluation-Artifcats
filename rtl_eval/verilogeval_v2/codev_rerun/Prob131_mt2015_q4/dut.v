module top_module (input x, input y, output z);
    wire z1,z2,z3,z4,z5,z6;
    A IA1(.x(x),.y(y),.z(z1));
    B IB1(.x(x),.y(y),.z(z2));
    A IA2(.x(x),.y(y),.z(z3));
    B IB2(.x(x),.y(y),.z(z4));
    or g1(z5,z1,z2);
    and g2(z6,z3,z4);
    xor g3(z,z5,z6);
endmodule
