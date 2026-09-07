IVERILOG = iverilog
VVP = vvp
YOSYS = yosys
NEXTPNR = nextpnr-ice40
ICEPACK = icepack
ICEPROG = iceprog

SIM_TARGET = calculadora_tb.vvp
HW_JSON = top.json
HW_ASC = top.asc
HW_BIN = top.bin

RTL = calcul_4bits.v \
      sumador_4bits.v \
      restador_4bits.v \
      des_izq.v \
      des_der.v \
      selector_ope2.v \
      selector_operaciones.v \
      registro_resultado.v

SIM = $(RTL) calculadora_4bits_tb_basico.sv
HW = $(RTL) top.v

sim:
	$(IVERILOG) -g2012 -o $(SIM_TARGET) $(SIM)
	$(VVP) $(SIM_TARGET)

synth:
	$(YOSYS) -p "read_verilog $(HW); synth_ice40 -top top -abc2 -relut -dffe_min_ce_use 4 -json $(HW_JSON); stat"

pnr: synth
	$(NEXTPNR) --hx1k --package vq100 --json $(HW_JSON) --pcf go_board.pcf --asc $(HW_ASC) --freq 25
	
bitstream: pnr
	$(ICEPACK) $(HW_ASC) $(HW_BIN)

program: bitstream
	$(ICEPROG) $(HW_BIN)

clean:
	rm -f $(SIM_TARGET) *.vcd $(HW_JSON) $(HW_ASC) $(HW_BIN)

all: sim
