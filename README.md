# Georgi - Quinteros - Riveros | Proyecto 1

## Arquitectura de Computadores

**Profesor:** Jorge Gómez

**Integrantes:**
- Christian Georgi
- Diego Quinteros
- Felipe Riveros

---

## Descripción del proyecto

Este proyecto consiste en la implementación de una calculadora de 4 bits utilizando Verilog y una FPGA Nandland Go Board con un dispositivo Lattice iCE40 HX1K.

La calculadora trabaja con números de 4 bits en complemento a 2 y permite realizar operaciones de suma, resta y desplazamiento de bits. Además, permite utilizar el resultado de una operación anterior como segundo operando de una nueva operación.

Las operaciones principales de la calculadora fueron implementadas mediante compuertas lógicas en Verilog.

---

## Operaciones disponibles

La operación se selecciona mediante un código de 3 bits:

| Código | Operación |
|--------|-----------|
| `000` | Reset del resultado |
| `001` | Suma: A + B |
| `010` | Resta: A - B |
| `011` | Resta inversa: B - A |
| `100` | Desplazamiento a la izquierda |
| `101` | Desplazamiento a la derecha |
| `110` | No utilizado |
| `111` | No utilizado |

Para los desplazamientos se utilizan los dos bits menos significativos del segundo operando para determinar la cantidad de posiciones a desplazar.

---

## Archivos principales

El proyecto se encuentra dividido en distintos módulos:

- `calcul_4bits.v`: módulo principal de la calculadora.
- `sumador_4bits.v`: sumador de 4 bits construido mediante Full Adders.
- `restador_4bits.v`: restador de 4 bits mediante complemento a 2.
- `des_izq.v`: desplazamiento lógico hacia la izquierda.
- `des_der.v`: desplazamiento lógico hacia la derecha.
- `selector_ope2.v`: selección entre el segundo operando externo y el resultado anterior.
- `selector_operaciones.v`: selección del resultado según el código de operación.
- `registro_resultado.v`: registro encargado de almacenar el resultado anterior.
- `top.v`: módulo utilizado para implementar la calculadora en la FPGA.
- `calculadora_4bits_tb_basico.sv`: testbench utilizado para comprobar el funcionamiento.
- `go_board.pcf`: asignación de pines de la Nandland Go Board.
- `Makefile`: automatiza la simulación, síntesis, generación del bitstream y programación.

---

## Requisitos

Para compilar, simular y programar el proyecto en otro computador es necesario contar con las siguientes herramientas:

- Git
- GNU Make
- Icarus Verilog (`iverilog`)
- GTKWave
- Yosys
- nextpnr-ice40
- Project IceStorm:
  - `icepack`
  - `iceprog`

Para programar físicamente la FPGA también es necesario disponer de:

- Nandland Go Board
- Cable USB
- Driver compatible con la interfaz FTDI de la placa

El proyecto fue desarrollado y probado utilizando Windows con MSYS2 UCRT64. También puede utilizarse otro sistema operativo siempre que las herramientas anteriores se encuentren instaladas y disponibles desde la terminal.

---

## Descargar el proyecto

Primero se debe clonar el repositorio:

```bash
git clone <URL-DEL-REPOSITORIO>
```

Luego ingresar a la carpeta:

```bash
cd Proyecto1_Arquitectura_computadores
```

> Reemplazar `<URL-DEL-REPOSITORIO>` por la dirección de este repositorio en GitHub.

---

## Simulación

Para compilar y ejecutar el testbench:

```bash
make sim
```

Este comando utiliza Icarus Verilog para compilar los módulos y ejecutar la simulación.

La simulación genera el archivo:

```text
calculadora_4bits_tb_basico.vcd
```

Este archivo contiene las señales generadas durante la simulación.

Para visualizar las señales utilizando GTKWave:

```bash
gtkwave calculadora_4bits_tb_basico.vcd
```

---

## Síntesis

Para realizar la síntesis del diseño utilizando Yosys:

```bash
make synth
```

Esto genera el archivo:

```text
top.json
```

---

## Place and Route

Para realizar el Place and Route para la FPGA Lattice iCE40 HX1K:

```bash
make pnr
```

Se utiliza `nextpnr-ice40` junto con el archivo de asignación de pines:

```text
go_board.pcf
```

Como resultado se genera:

```text
top.asc
```

---

## Generación del bitstream

Para generar el archivo que posteriormente será cargado a la FPGA:

```bash
make bitstream
```

Esto utiliza `icepack` y genera:

```text
top.bin
```

---

## Programación de la FPGA

Con la Nandland Go Board conectada al computador mediante USB, ejecutar:

```bash
make program
```

También es posible programarla directamente utilizando:

```bash
iceprog top.bin
```

Una vez finalizada correctamente la programación, la calculadora queda disponible para ser utilizada mediante los botones, LEDs y displays de 7 segmentos de la placa.

---

## Uso de la calculadora en la FPGA

La Nandland Go Board posee cuatro botones utilizados para controlar la calculadora.

| Botón | Función |
|-------|---------|
| SW1 | Aumentar el valor seleccionado |
| SW2 | Disminuir el valor seleccionado |
| SW3 | Confirmar el valor y avanzar |
| SW4 | Seleccionar el resultado anterior como segundo operando |

### 1. Seleccionar operación

Al iniciar la calculadora se selecciona el código de operación.

Los tres primeros LEDs representan el código de la operación seleccionada.

Con SW1 y SW2 se puede aumentar o disminuir el código.

Una vez seleccionada la operación, presionar SW3 para confirmar.

### 2. Ingresar primer operando

Utilizar:

- SW1 para aumentar el valor.
- SW2 para disminuir el valor.

El valor seleccionado se muestra en los displays de 7 segmentos.

Presionar SW3 para confirmar el primer operando.

### 3. Ingresar segundo operando

El segundo operando se selecciona de la misma manera utilizando SW1 y SW2.

También es posible presionar SW4 para utilizar el resultado de la operación anterior como segundo operando.

El LED 4 indica cuando se encuentra seleccionada esta opción.

Presionar SW3 para ejecutar la operación.

### 4. Resultado

El resultado de la operación se muestra en los displays de 7 segmentos.

Los números negativos se representan utilizando el primer display para el signo negativo y el segundo display para mostrar la magnitud.

Por ejemplo:

```text
-2
```

se muestra mediante el signo `-` en el primer display y el número `2` en el segundo.

Para volver a seleccionar una nueva operación, presionar nuevamente SW3.

---

## Uso del resultado anterior

La calculadora permite reutilizar el resultado de la operación anterior.

Por ejemplo, si primero se realiza:

```text
2 + 3 = 5
```

se puede iniciar una nueva operación, ingresar `1` como primer operando y presionar SW4 durante la selección del segundo operando.

De esta forma:

```text
1 + resultado_anterior
```

equivale a:

```text
1 + 5 = 6
```

---

## Reset

La operación:

```text
000
```

reinicia el resultado almacenado a:

```text
0000
```

Para realizar el reset se debe seleccionar `000` y confirmar mediante SW3.

---

## Limpiar archivos generados

Para eliminar los archivos creados durante la simulación, síntesis y generación del bitstream:

```bash
make clean
```

---

## Flujo completo

Para comprobar el proyecto desde un computador nuevo, el procedimiento general es:

```text
1. Instalar las herramientas necesarias.
2. Clonar el repositorio.
3. Ingresar a la carpeta del proyecto.
4. Ejecutar `make sim`.
5. Revisar la simulación con GTKWave.
6. Ejecutar `make bitstream`.
7. Conectar la Nandland Go Board.
8. Ejecutar `make program` o `iceprog top.bin`.
9. Probar las operaciones utilizando los cuatro botones de la FPGA.
```
