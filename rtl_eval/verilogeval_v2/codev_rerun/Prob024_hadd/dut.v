module TopModule( 
    input a, b,
    output cout, sum );
    assign {cout, sum} = a + b;
endmodule
