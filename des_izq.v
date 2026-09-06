module desplazamiento_izq (
    input wire [3:0] A,
    input wire [1:0] cantidad,
    output wire [3:0] S
);

    wire [3:0] shift1;
    wire [3:0] shift2;

    // Desplazamiento de 1 posición
    buf b10 (shift1[1], A[0]);
    buf b11 (shift1[2], A[1]);
    buf b12 (shift1[3], A[2]);
    // shift1[0] = 0

    // Desplazamiento de 2 posiciones
    buf b20 (shift2[2], A[0]);
    buf b21 (shift2[3], A[1]);
    // shift2[0] = 0
    // shift2[1] = 0

    // Selección según cantidad
    // cantidad = 00 -> A
    // cantidad = 01 -> A << 1
    // cantidad = 10 -> A << 2
    // cantidad = 11 -> A << 3

    wire n0;
    wire n1;

    not n_0 (n0, cantidad[0]);
    not n_1 (n1, cantidad[1]);

    wire sel0;
    wire sel1;
    wire sel2;
    wire sel3;

    // 00
    and a00_0 (sel0, n1, n0);

    // 01
    and a01_0 (sel1, n1, cantidad[0]);

    // 10
    and a10_0 (sel2, cantidad[1], n0);

    // 11
    and a11_0 (sel3, cantidad[1], cantidad[0]);

    // Salida
    wire [3:0] r0;
    wire [3:0] r1;
    wire [3:0] r2;
    wire [3:0] r3;

    // cantidad = 00
    and g00_0 (r0[0], A[0], sel0);
    and g00_1 (r0[1], A[1], sel0);
    and g00_2 (r0[2], A[2], sel0);
    and g00_3 (r0[3], A[3], sel0);

    // cantidad = 01
    and g01_0 (r1[0], 1'b0, sel1);
    and g01_1 (r1[1], shift1[1], sel1);
    and g01_2 (r1[2], shift1[2], sel1);
    and g01_3 (r1[3], shift1[3], sel1);

    // cantidad = 10
    and g10_0 (r2[0], 1'b0, sel2);
    and g10_1 (r2[1], 1'b0, sel2);
    and g10_2 (r2[2], shift2[2], sel2);
    and g10_3 (r2[3], shift2[3], sel2);

    // cantidad = 11 -> A << 3
    and g11_0 (r3[0], 1'b0, sel3);
    and g11_1 (r3[1], 1'b0, sel3);
    and g11_2 (r3[2], 1'b0, sel3);
    and g11_3 (r3[3], A[0], sel3);

    or o0 (S[0], r0[0], r1[0], r2[0], r3[0]);
    or o1 (S[1], r0[1], r1[1], r2[1], r3[1]);
    or o2 (S[2], r0[2], r1[2], r2[2], r3[2]);
    or o3 (S[3], r0[3], r1[3], r2[3], r3[3]);

endmodule