module registro_resultado (
    input wire clk,
    input wire ejecutar,
    input wire reset,
    input wire [3:0] resultado_calculado,
    output reg [3:0] resultado
);

    always @(posedge clk) begin

        if (reset)
            resultado <= 4'b0000;

        else if (ejecutar)
            resultado <= resultado_calculado;

    end

endmodule