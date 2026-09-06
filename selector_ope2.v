module selector_op2 (
    input wire [3:0] op2_ext,
    input wire [3:0] resultado_anterior,
    input wire sel_op2,
    output wire [3:0] op2
);

    wire n_sel;

    not inv (n_sel, sel_op2);

    // Cuando sel_op2 = 0, se selecciona op2_ext
    // Cuando sel_op2 = 1, se selecciona resultado_anterior

    wire [3:0] externo;
    wire [3:0] anterior;

    and e0 (externo[0], op2_ext[0], n_sel);
    and e1 (externo[1], op2_ext[1], n_sel);
    and e2 (externo[2], op2_ext[2], n_sel);
    and e3 (externo[3], op2_ext[3], n_sel);

    and a0 (anterior[0], resultado_anterior[0], sel_op2);
    and a1 (anterior[1], resultado_anterior[1], sel_op2);
    and a2 (anterior[2], resultado_anterior[2], sel_op2);
    and a3 (anterior[3], resultado_anterior[3], sel_op2);

    or o0 (op2[0], externo[0], anterior[0]);
    or o1 (op2[1], externo[1], anterior[1]);
    or o2 (op2[2], externo[2], anterior[2]);
    or o3 (op2[3], externo[3], anterior[3]);

endmodule