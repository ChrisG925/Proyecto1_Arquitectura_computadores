IVERILOG = iverilog
VVP = vvp

TARGET = calculadora_tb.vvp

SOURCES = calcul_4bits.v \
          sumador_4bits.v \
          restador_4bits.v \
          des_izq.v \
          des_der.v \
          selector_ope2.v \
          selector_operaciones.v \
          registro_resultado.v \
          calculadora_4bits_tb_basico.sv
compile:
	$(IVERILOG) -g2012 -o $(TARGET) $(SOURCES)

run: compile
	$(VVP) $(TARGET)

wave: run
	gtkwave calculadora_4_bits_tb_basico.vcd

clean:
	rm -f $(TARGET)
	rm -f *.vcd

all: run