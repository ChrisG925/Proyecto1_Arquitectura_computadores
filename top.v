module top (
    input  wire i_Clk,

    input  wire i_Switch_1,
    input  wire i_Switch_2,
    input  wire i_Switch_3,
    input  wire i_Switch_4,

    output wire o_LED_1,
    output wire o_LED_2,
    output wire o_LED_3,
    output wire o_LED_4,

    output wire o_Segment1_A,
    output wire o_Segment1_B,
    output wire o_Segment1_C,
    output wire o_Segment1_D,
    output wire o_Segment1_E,
    output wire o_Segment1_F,
    output wire o_Segment1_G,

    output wire o_Segment2_A,
    output wire o_Segment2_B,
    output wire o_Segment2_C,
    output wire o_Segment2_D,
    output wire o_Segment2_E,
    output wire o_Segment2_F,
    output wire o_Segment2_G
);

    // =====================================================
    // BOTONES
    // =====================================================

    wire pulso_sw1;
    wire pulso_sw2;
    wire pulso_sw3;
    wire pulso_sw4;

    debounce DB1 (
        .clk(i_Clk),
        .boton(i_Switch_1),
        .pulso(pulso_sw1)
    );

    debounce DB2 (
        .clk(i_Clk),
        .boton(i_Switch_2),
        .pulso(pulso_sw2)
    );

    debounce DB3 (
        .clk(i_Clk),
        .boton(i_Switch_3),
        .pulso(pulso_sw3)
    );

    debounce DB4 (
        .clk(i_Clk),
        .boton(i_Switch_4),
        .pulso(pulso_sw4)
    );


    // =====================================================
    // ESTADOS
    // =====================================================

    localparam EST_OPERACION = 2'b00;
    localparam EST_OP1       = 2'b01;
    localparam EST_OP2       = 2'b10;
    localparam EST_RESULTADO = 2'b11;

    reg [1:0] estado = EST_OPERACION;


    // =====================================================
    // REGISTROS
    // =====================================================

    reg [2:0] codigo_reg = 3'b000;
    reg [3:0] op1_reg = 4'b0000;
    reg [3:0] op2_reg = 4'b0000;

    reg sel_op2_reg = 1'b0;

    wire [3:0] resultado;


    // =====================================================
    // CONTROL
    // =====================================================

    always @(posedge i_Clk) begin

        case (estado)

            // ---------------------------------------------
            // SELECCION DE OPERACION
            // ---------------------------------------------
            EST_OPERACION: begin

                sel_op2_reg <= 1'b0;

                // SW1: aumentar codigo
                if (pulso_sw1) begin

                    if (codigo_reg == 3'b101)
                        codigo_reg <= 3'b000;
                    else
                        codigo_reg <= codigo_reg + 1'b1;

                end

                // SW2: disminuir codigo
                if (pulso_sw2) begin

                    if (codigo_reg == 3'b000)
                        codigo_reg <= 3'b101;
                    else
                        codigo_reg <= codigo_reg - 1'b1;

                end

                // SW3: confirmar operacion
                if (pulso_sw3) begin

                    // Si es 000, se ejecuta reset
                    if (codigo_reg == 3'b000) begin

                        estado <= EST_RESULTADO;
                        op1_reg <= 4'b0000;
                        op2_reg <= 4'b0000;
                        sel_op2_reg <= 1'b0;

                    end
                    else begin

                        estado <= EST_OP1;
                        op1_reg <= 4'b0000;

                    end

                end

            end


            // ---------------------------------------------
            // PRIMER OPERANDO
            // ---------------------------------------------
            EST_OP1: begin

                if (pulso_sw1)
                    op1_reg <= op1_reg + 1'b1;

                if (pulso_sw2)
                    op1_reg <= op1_reg - 1'b1;

                if (pulso_sw3) begin

                    estado <= EST_OP2;
                    op2_reg <= 4'b0000;
                    sel_op2_reg <= 1'b0;

                end

            end


            // ---------------------------------------------
            // SEGUNDO OPERANDO
            // ---------------------------------------------
            EST_OP2: begin

                if (pulso_sw1)
                    op2_reg <= op2_reg + 1'b1;

                if (pulso_sw2)
                    op2_reg <= op2_reg - 1'b1;

                if (pulso_sw4)
                    sel_op2_reg <= ~sel_op2_reg;

                if (pulso_sw3)
                    estado <= EST_RESULTADO;

            end


            // ---------------------------------------------
            // RESULTADO
            // ---------------------------------------------
            EST_RESULTADO: begin

                if (pulso_sw3) begin

                    estado <= EST_OPERACION;

                    codigo_reg <= 3'b000;
                    op1_reg <= 4'b0000;
                    op2_reg <= 4'b0000;
                    sel_op2_reg <= 1'b0;

                end

            end


            default: begin
                estado <= EST_OPERACION;
            end

        endcase

    end


    // =====================================================
    // EJECUCION
    // =====================================================

    wire ejecutar_calculadora;

    assign ejecutar_calculadora =
        ((estado == EST_OP2) && pulso_sw3) ||
        ((estado == EST_OPERACION) &&
         (codigo_reg == 3'b000) &&
         pulso_sw3);


    // =====================================================
    // CALCULADORA
    // =====================================================

    calculadora_4bits CALCULADORA (
        .clk(i_Clk),
        .ejecutar(ejecutar_calculadora),
        .codigo(codigo_reg),
        .sel_op2(sel_op2_reg),
        .op1(op1_reg),
        .op2_ext(op2_reg),
        .resultado(resultado)
    );


    // =====================================================
    // LEDs
    // =====================================================

    assign o_LED_1 =
        (estado == EST_OPERACION) ? codigo_reg[0] : 1'b0;

    assign o_LED_2 =
        (estado == EST_OPERACION) ? codigo_reg[1] : 1'b0;

    assign o_LED_3 =
        (estado == EST_OPERACION) ? codigo_reg[2] : 1'b0;

    assign o_LED_4 = sel_op2_reg;


    // =====================================================
    // VALOR A MOSTRAR
    // =====================================================

    reg [3:0] valor_display;

    always @(*) begin

        case (estado)

            EST_OP1:
                valor_display = op1_reg;

            EST_OP2: begin

                if (sel_op2_reg)
                    valor_display = resultado;
                else
                    valor_display = op2_reg;

            end

            EST_RESULTADO:
                valor_display = resultado;

            default:
                valor_display = 4'b0000;

        endcase

    end


    // =====================================================
    // SIGNO + MAGNITUD
    // =====================================================

    wire es_negativo;
    wire [3:0] valor_invertido;
    wire [3:0] magnitud;

    assign es_negativo = valor_display[3];

    assign valor_invertido = ~valor_display;

    assign magnitud =
        es_negativo
        ? (valor_invertido + 1'b1)
        : valor_display;


    // =====================================================
    // 7 SEGMENTOS
    // =====================================================

    wire [6:0] seg_signo;
    wire [6:0] seg_valor;

    assign seg_signo =
        es_negativo
        ? 7'b0000001
        : 7'b0000000;


    seven_segment DISPLAY_VALOR (
        .valor(magnitud),
        .segmentos(seg_valor)
    );


    // =====================================================
    // DISPLAY 1: SIGNO
    // =====================================================

    assign o_Segment1_A = ~seg_signo[6];
    assign o_Segment1_B = ~seg_signo[5];
    assign o_Segment1_C = ~seg_signo[4];
    assign o_Segment1_D = ~seg_signo[3];
    assign o_Segment1_E = ~seg_signo[2];
    assign o_Segment1_F = ~seg_signo[1];
    assign o_Segment1_G = ~seg_signo[0];


    // =====================================================
    // DISPLAY 2: NUMERO
    // =====================================================

    assign o_Segment2_A = ~seg_valor[6];
    assign o_Segment2_B = ~seg_valor[5];
    assign o_Segment2_C = ~seg_valor[4];
    assign o_Segment2_D = ~seg_valor[3];
    assign o_Segment2_E = ~seg_valor[2];
    assign o_Segment2_F = ~seg_valor[1];
    assign o_Segment2_G = ~seg_valor[0];

endmodule



// =========================================================
// DEBOUNCE
// =========================================================

module debounce (
    input  wire clk,
    input  wire boton,
    output reg  pulso = 1'b0
);

    reg [17:0] contador = 18'd0;

    reg estado_estable = 1'b0;
    reg estado_anterior = 1'b0;

    always @(posedge clk) begin

        pulso <= 1'b0;

        if (boton == estado_estable) begin

            contador <= 18'd0;

        end
        else begin

            if (contador == 18'd249999) begin

                estado_estable <= boton;
                contador <= 18'd0;

            end
            else begin

                contador <= contador + 1'b1;

            end

        end

        estado_anterior <= estado_estable;

        if (estado_estable && !estado_anterior)
            pulso <= 1'b1;

    end

endmodule



// =========================================================
// HEX -> 7 SEGMENTOS
// =========================================================

module seven_segment (
    input  wire [3:0] valor,
    output reg  [6:0] segmentos
);

    always @(*) begin

        case (valor)

            4'h0: segmentos = 7'b1111110;
            4'h1: segmentos = 7'b0110000;
            4'h2: segmentos = 7'b1101101;
            4'h3: segmentos = 7'b1111001;

            4'h4: segmentos = 7'b0110011;
            4'h5: segmentos = 7'b1011011;
            4'h6: segmentos = 7'b1011111;
            4'h7: segmentos = 7'b1110000;

            4'h8: segmentos = 7'b1111111;
            4'h9: segmentos = 7'b1111011;
            4'hA: segmentos = 7'b1110111;
            4'hB: segmentos = 7'b0011111;

            4'hC: segmentos = 7'b1001110;
            4'hD: segmentos = 7'b0111101;
            4'hE: segmentos = 7'b1001111;
            4'hF: segmentos = 7'b1000111;

            default:
                segmentos = 7'b0000000;

        endcase

    end

endmodule