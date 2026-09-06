module calculadora_4bits (
    input  wire       clk,
    input  wire       ejecutar,
    input  wire [2:0] codigo,
    input  wire       sel_op2,
    input  wire [3:0] op1,
    input  wire [3:0] op2_ext,
    output wire [3:0] resultado
);

    // =====================================================
    // SEÑALES INTERNAS
    // =====================================================

    wire [3:0] op2;

    wire [3:0] suma;
    wire [3:0] resta;
    wire [3:0] resta_inversa;

    wire [3:0] shift_izq;
    wire [3:0] shift_der;

    wire [3:0] resultado_calculado;
    wire [3:0] resultado_anterior;

    // Señal de reset para codigo = 000
    wire n_codigo0;
    wire n_codigo1;
    wire n_codigo2;
    wire reset_codigo;


    // =====================================================
    // RESET
    // codigo = 000
    // =====================================================

    not inv_codigo0 (n_codigo0, codigo[0]);
    not inv_codigo1 (n_codigo1, codigo[1]);
    not inv_codigo2 (n_codigo2, codigo[2]);

    and reset_gate (
        reset_codigo,
        n_codigo2,
        n_codigo1,
        n_codigo0
    );


    // =====================================================
    // SELECTOR DEL SEGUNDO OPERANDO
    //
    // sel_op2 = 0 -> op2_ext
    // sel_op2 = 1 -> resultado anterior
    // =====================================================

    selector_ope2 SEL_OP2 (
        .op2_ext(op2_ext),
        .resultado_anterior(resultado_anterior),
        .sel_op2(sel_op2),
        .op2(op2)
    );


    // =====================================================
    // SUMA
    // codigo = 001
    // =====================================================

    sumador_4bits SUMADOR (
        .A(op1),
        .B(op2),
        .S(suma)
    );


    // =====================================================
    // RESTA
    // codigo = 010
    // A - B
    // =====================================================

    restador_4bits RESTADOR (
        .A(op1),
        .B(op2),
        .S(resta)
    );


    // =====================================================
    // RESTA INVERSA
    // codigo = 011
    // B - A
    // =====================================================

    restador_4bits RESTADOR_INVERSO (
        .A(op2),
        .B(op1),
        .S(resta_inversa)
    );


    // =====================================================
    // DESPLAZAMIENTO IZQUIERDA
    // codigo = 100
    // A << B[1:0]
    // =====================================================

    des_izq DESPLAZAMIENTO_IZQ (
        .A(op1),
        .cantidad(op2[1:0]),
        .S(shift_izq)
    );


    // =====================================================
    // DESPLAZAMIENTO DERECHA
    // codigo = 101
    // A >> B[1:0]
    // =====================================================

    des_der DESPLAZAMIENTO_DER (
        .A(op1),
        .cantidad(op2[1:0]),
        .S(shift_der)
    );


    // =====================================================
    // SELECTOR DE OPERACIONES
    // =====================================================

    selector_operaciones SELECTOR (
        .codigo(codigo),
        .suma(suma),
        .resta(resta),
        .resta_inversa(resta_inversa),
        .shift_izq(shift_izq),
        .shift_der(shift_der),
        .resultado(resultado_calculado)
    );


    // =====================================================
    // REGISTRO DEL RESULTADO
    // =====================================================

    registro_resultados REGISTRO (
        .clk(clk),
        .ejecutar(ejecutar),
        .reset(reset_codigo),
        .resultado_calculado(resultado_calculado),
        .resultado(resultado_anterior)
    );


    // =====================================================
    // SALIDA
    // =====================================================

    assign resultado = resultado_anterior;

endmodule