`timescale 1ns/1ps

module testbench;

    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] S;

    sumador_4bits DUT (
        .A(A),
        .B(B),
        .S(S)
    );

    initial begin

        $dumpfile("sumador.vcd");
        $dumpvars(0, testbench);

        // Prueba 1: 3 + 2
        A = 4'b0011;
        B = 4'b0010;
        #10;

        // Prueba 2: 5 + 4
        A = 4'b0101;
        B = 4'b0100;
        #10;

        // Prueba 3: 7 + 8
        A = 4'b0111;
        B = 4'b1000;
        #10;

        // Prueba 4: overflow
        A = 4'b1111;
        B = 4'b0001;
        #10;

        $finish;

    end

endmodule