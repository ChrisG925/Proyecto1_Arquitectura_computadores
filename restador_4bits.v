module restador_4bits (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S
);

    wire [3:0] Bn;
    wire C1;
    wire C2;
    wire C3;
    wire C4;

    
    not n0 (Bn[0], B[0]);
    not n1 (Bn[1], B[1]);
    not n2 (Bn[2], B[2]);
    not n3 (Bn[3], B[3]);

    

    full_adder FA0 (
        .A(A[0]),
        .B(Bn[0]),
        .Cin(1'b1),
        .S(S[0]),
        .Cout(C1)
    );

    full_adder FA1 (
        .A(A[1]),
        .B(Bn[1]),
        .Cin(C1),
        .S(S[1]),
        .Cout(C2)
    );

    full_adder FA2 (
        .A(A[2]),
        .B(Bn[2]),
        .Cin(C2),
        .S(S[2]),
        .Cout(C3)
    );

    full_adder FA3 (
        .A(A[3]),
        .B(Bn[3]),
        .Cin(C3),
        .S(S[3]),
        .Cout(C4)
    );

endmodule