module full_adder (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

    wire x;
    wire c1;
    wire c2;

    xor g1 (x, A, B);
    xor g2 (S, x, Cin);

    and g3 (c1, A, B);
    and g4 (c2, x, Cin);

    or g5 (Cout, c1, c2);

endmodule


module sumador_4bits (
    input  [3:0] A,
    input  [3:0] B,
    output [3:0] S
);

    wire c1;
    wire c2;
    wire c3;
    wire c4;

    full_adder FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(1'b0),
        .S(S[0]),
        .Cout(c1)
    );

    full_adder FA1 (
        .A(A[1]),
        .B(B[1]),
        .Cin(c1),
        .S(S[1]),
        .Cout(c2)
    );

    full_adder FA2 (
        .A(A[2]),
        .B(B[2]),
        .Cin(c2),
        .S(S[2]),
        .Cout(c3)
    );

    full_adder FA3 (
        .A(A[3]),
        .B(B[3]),
        .Cin(c3),
        .S(S[3]),
        .Cout(c4)
    );

endmodule