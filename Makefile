# ==========================================
# Makefile - Calculadora 4 bits
# ==========================================

IVERILOG = iverilog
VVP = vvp

TARGET = calculadora_tb.vvp

SOURCES = \
	calculadora_4bits.v \
	sumador_4bits.v \
	restador_4bits.v \
	des_izq.v \
	des_der.v \
	selector_ope2.v \
	selector_operaciones.v \
	registro_resultados.v \
	calculadora_4_bits_tb_basico.sv

# Compilar
compile:
	$(IVERILOG) -g2012 -o $(TARGET) $(SOURCES)

# Compilar y ejecutar
run: compile
	$(VVP) $(TARGET)

# Abrir GTKWave si se generó el VCD
wave: run
	gtkwave calculadora_4bits_tb_basico.vcd

# Limpiar archivos generados
clean:
	rm -f $(TARGET)
	rm -f *.vcd

# Ejecutar todo
all: run