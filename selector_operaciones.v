module selector_operaciones (
    input wire [2:0] codigo,

    input wire [3:0] suma,
    input wire [3:0] resta,
    input wire [3:0] resta_inversa,
    input wire [3:0] shift_izq,
    input wire [3:0] shift_der,

    output wire [3:0] resultado
);

    wire n0;
    wire n1;
    wire n2;

    not inv0 (n0, codigo[0]);
    not inv1 (n1, codigo[1]);
    not inv2 (n2, codigo[2]);

    
    wire sel_suma;
    wire sel_resta;
    wire sel_resta_inv;
    wire sel_izq;
    wire sel_der;

   
    and s0 (sel_suma, n2, n1, codigo[0]);

    
    and s1 (sel_resta, n2, codigo[1], n0);

    
    and s2 (sel_resta_inv, n2, codigo[1], codigo[0]);

    
    and s3 (sel_izq, codigo[2], n1, n0);

    
    and s4 (sel_der, codigo[2], n1, codigo[0]);

    wire [3:0] r_suma;
    wire [3:0] r_resta;
    wire [3:0] r_resta_inv;
    wire [3:0] r_izq;
    wire [3:0] r_der;

    
    and as0 (r_suma[0], suma[0], sel_suma);
    and as1 (r_suma[1], suma[1], sel_suma);
    and as2 (r_suma[2], suma[2], sel_suma);
    and as3 (r_suma[3], suma[3], sel_suma);

    and ar0 (r_resta[0], resta[0], sel_resta);
    and ar1 (r_resta[1], resta[1], sel_resta);
    and ar2 (r_resta[2], resta[2], sel_resta);
    and ar3 (r_resta[3], resta[3], sel_resta);

    and ari0 (r_resta_inv[0], resta_inversa[0], sel_resta_inv);
    and ari1 (r_resta_inv[1], resta_inversa[1], sel_resta_inv);
    and ari2 (r_resta_inv[2], resta_inversa[2], sel_resta_inv);
    and ari3 (r_resta_inv[3], resta_inversa[3], sel_resta_inv);

    and ai0 (r_izq[0], shift_izq[0], sel_izq);
    and ai1 (r_izq[1], shift_izq[1], sel_izq);
    and ai2 (r_izq[2], shift_izq[2], sel_izq);
    and ai3 (r_izq[3], shift_izq[3], sel_izq);

    and ad0 (r_der[0], shift_der[0], sel_der);
    and ad1 (r_der[1], shift_der[1], sel_der);
    and ad2 (r_der[2], shift_der[2], sel_der);
    and ad3 (r_der[3], shift_der[3], sel_der);

    
    or o0 (resultado[0],
           r_suma[0],
           r_resta[0],
           r_resta_inv[0],
           r_izq[0],
           r_der[0]);

    or o1 (resultado[1],
           r_suma[1],
           r_resta[1],
           r_resta_inv[1],
           r_izq[1],
           r_der[1]);

    or o2 (resultado[2],
           r_suma[2],
           r_resta[2],
           r_resta_inv[2],
           r_izq[2],
           r_der[2]);

    or o3 (resultado[3],
           r_suma[3],
           r_resta[3],
           r_resta_inv[3],
           r_izq[3],
           r_der[3]);

endmodule