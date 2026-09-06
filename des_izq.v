module des_izq (
    input wire [3:0] A,
    input wire [1:0] cantidad,
    output wire [3:0] S
);

    wire [3:0] s1;
    wire [3:0] s2;
    wire [3:0] s3;

    // A << 1
    buf b1_1 (s1[1], A[0]);
    buf b1_2 (s1[2], A[1]);
    buf b1_3 (s1[3], A[2]);
    buf b1_0 (s1[0], 1'b0);

    // A << 2
    buf b2_2 (s2[2], A[0]);
    buf b2_3 (s2[3], A[1]);
    buf b2_0 (s2[0], 1'b0);
    buf b2_1 (s2[1], 1'b0);

    // A << 3
    buf b3_3 (s3[3], A[0]);
    buf b3_0 (s3[0], 1'b0);
    buf b3_1 (s3[1], 1'b0);
    buf b3_2 (s3[2], 1'b0);

    wire n0;
    wire n1;

    not n_0 (n0, cantidad[0]);
    not n_1 (n1, cantidad[1]);

    wire sel0;
    wire sel1;
    wire sel2;
    wire sel3;

    // 00
    and a0 (sel0, n1, n0);

    // 01
    and a1 (sel1, n1, cantidad[0]);

    // 10
    and a2 (sel2, cantidad[1], n0);

    // 11
    and a3 (sel3, cantidad[1], cantidad[0]);

    wire [3:0] r0;
    wire [3:0] r1;
    wire [3:0] r2;
    wire [3:0] r3;

    and g00 (r0[0], A[0], sel0);
    and g01 (r0[1], A[1], sel0);
    and g02 (r0[2], A[2], sel0);
    and g03 (r0[3], A[3], sel0);

    and g10 (r1[0], s1[0], sel1);
    and g11 (r1[1], s1[1], sel1);
    and g12 (r1[2], s1[2], sel1);
    and g13 (r1[3], s1[3], sel1);

    and g20 (r2[0], s2[0], sel2);
    and g21 (r2[1], s2[1], sel2);
    and g22 (r2[2], s2[2], sel2);
    and g23 (r2[3], s2[3], sel2);

    and g30 (r3[0], s3[0], sel3);
    and g31 (r3[1], s3[1], sel3);
    and g32 (r3[2], s3[2], sel3);
    and g33 (r3[3], s3[3], sel3);

    or o0 (S[0], r0[0], r1[0], r2[0], r3[0]);
    or o1 (S[1], r0[1], r1[1], r2[1], r3[1]);
    or o2 (S[2], r0[2], r1[2], r2[2], r3[2]);
    or o3 (S[3], r0[3], r1[3], r2[3], r3[3]);

endmodule