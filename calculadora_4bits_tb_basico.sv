`timescale 1ns/1ps

`timescale 1ns/1ps

module calculadora_4bits_tb_basico;

  logic clk;
  logic ejecutar;
  logic [2:0] codigo;
  logic sel_op2;
  logic [3:0] op1;
  logic [3:0] op2_ext;
  logic [3:0] resultado;

  calculadora_4bits dut (
    .clk(clk),
    .ejecutar(ejecutar),
    .codigo(codigo),
    .sel_op2(sel_op2),
    .op1(op1),
    .op2_ext(op2_ext),
    .resultado(resultado)
  );

  localparam RESET       = 3'b000;
  localparam SUMA        = 3'b001;
  localparam RESTA       = 3'b010;
  localparam RESTA_INV   = 3'b011;
  localparam SHIFT_IZQ   = 3'b100;
  localparam SHIFT_DER   = 3'b101;
  localparam CODIGO_110  = 3'b110;
  localparam CODIGO_111  = 3'b111;

  always #5 clk = ~clk;

  task automatic pulso_ejecutar;
    begin
      ejecutar = 1'b1;
      @(posedge clk);
      #1;
      ejecutar = 1'b0;
      @(posedge clk);
      #1;
    end
  endtask

  task automatic probar;
    input [2:0] cod;
    input [3:0] a;
    input [3:0] b;
    input [3:0] esperado;
    input string nombre;

    begin
      codigo  = cod;
      sel_op2 = 1'b0;
      op1     = a;
      op2_ext = b;

      pulso_ejecutar();

      if (resultado !== esperado) begin
        $display("FAIL %s", nombre);
        $display("  codigo   = %b", cod);
        $display("  op1      = %b", a);
        $display("  op2_ext  = %b", b);
        $display("  esperado = %b", esperado);
        $display("  obtenido = %b", resultado);
        $fatal;
      end
      else begin
        $display("PASS %s: resultado = %b", nombre, resultado);
      end
    end
  endtask

  task automatic probar_resultado_anterior;
    input [2:0] cod;
    input [3:0] a;
    input [3:0] esperado;
    input string nombre;

    begin
      codigo  = cod;
      sel_op2 = 1'b1;
      op1     = a;
      op2_ext = 4'b0000;

      pulso_ejecutar();

      if (resultado !== esperado) begin
        $display("FAIL %s", nombre);
        $display("  codigo   = %b", cod);
        $display("  op1      = %b", a);
        $display("  esperado = %b", esperado);
        $display("  obtenido = %b", resultado);
        $fatal;
      end
      else begin
        $display("PASS %s: resultado = %b", nombre, resultado);
      end
    end
  endtask

  initial begin

    $dumpfile("calculadora_4bits_tb_basico.vcd");
    $dumpvars(0, calculadora_4bits_tb_basico);

    clk = 1'b0;
    ejecutar = 1'b0;
    codigo = RESET;
    sel_op2 = 1'b0;
    op1 = 4'b0000;
    op2_ext = 4'b0000;

    repeat (2) @(posedge clk);


    probar(
      SUMA,
      4'b0011,
      4'b0100,
      4'b0111,
      "suma 3 + 4 = 7"
    );

    probar(
      SUMA,
      4'b1110,
      4'b0011,
      4'b0001,
      "suma -2 + 3 = 1"
    );

    probar(
      SUMA,
      4'b0111,
      4'b0011,
      4'b1010,
      "suma con overflow 7 + 3"
    );


    probar(
      RESTA,
      4'b0101,
      4'b0010,
      4'b0011,
      "resta 5 - 2 = 3"
    );

    probar(
      RESTA,
      4'b0010,
      4'b0101,
      4'b1101,
      "resta 2 - 5 = -3"
    );

    probar(
      RESTA,
      4'b1011,
      4'b1110,
      4'b1101,
      "resta -5 - (-2) = -3"
    );



    probar(
      RESTA_INV,
      4'b0011,
      4'b0101,
      4'b0010,
      "resta inversa 5 - 3 = 2"
    );

    probar(
      RESTA_INV,
      4'b0101,
      4'b0010,
      4'b1101,
      "resta inversa 2 - 5 = -3"
    );

    probar(
      SHIFT_IZQ,
      4'b1100,
      4'b0001,
      4'b1000,
      "shift izquierda 12 << 1 = 8"
    );

    probar(
      SHIFT_IZQ,
      4'b0011,
      4'b0010,
      4'b1100,
      "shift izquierda 3 << 2 = 12"
    );


    probar(
      SHIFT_DER,
      4'b1100,
      4'b0001,
      4'b0110,
      "shift derecha 12 >> 1 = 6"
    );

    probar(
      SHIFT_DER,
      4'b1100,
      4'b0010,
      4'b0011,
      "shift derecha 12 >> 2 = 3"
    );


    probar(
      SUMA,
      4'b0011,
      4'b0100,
      4'b0111,
      "guardar resultado anterior = 7"
    );

    probar_resultado_anterior(
      SUMA,
      4'b0010,
      4'b1001,
      "sel_op2 usando resultado anterior: 2 + 7 = 9"
    );


   

    probar_resultado_anterior(
      RESTA,
      4'b0011,
      4'b1010,
      "sel_op2 resta: 3 - 9 = -6"
    );


    
    probar(
      RESET,
      4'b0000,
      4'b0000,
      4'b0000,
      "reset = 0"
    );


    
    probar(
      CODIGO_110,
      4'b0101,
      4'b0011,
      4'b0000,
      "codigo 110 no utilizado"
    );

    probar(
      CODIGO_111,
      4'b0101,
      4'b0011,
      4'b0000,
      "codigo 111 no utilizado"
    );


    $display("");
    $display("========================================");
    $display("TODOS LOS TESTS PASARON!");
    $display("========================================");

    $finish;

  end

endmodule