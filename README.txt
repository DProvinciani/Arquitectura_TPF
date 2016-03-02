Trabajo Practico Final - Arquitectura de Computadoras 2015

Instrucciones

1-Estructura de archivos
.
├── Codigo_fuente
│   ├── 11-general
│   ├── 1-instruction_fetch
│   ├── 2-instruction_decode
│   ├── 3-execution
│   ├── 4-memory
│   ├── 5-write_back
│   ├── 6-pipe_registers
│   ├── 7-uart
│   ├── 8-hazards
│   ├── 9-test_bench
│   └── ipcore_dir
├── Compilador
│   ├── assembler
│   ├── compiler.py
│   ├── instruction_generator
│   ├── README.txt
│   └── result
├── integrantes.txt
├── MIcomPS
│   ├── components
│   ├── log
│   ├── MIcomPS.py
│   ├── README.txt
│   ├── utils
│   └── wxPython
├── README.txt
└── Testing
    ├── System_test
    │   ├── dataMemory.coe
    │   ├── README.txt
    │   ├── test_1
    │   ├── test_2
    │   ├── test_3
    │   └── test_4
    └── Test_bench
        ├── pipeline_tb.v
        └── tp_final_tb.v

2-Compilador
	Permite compilar un programa escrito en lenguaje ensamblador de MIPS para generar el file.coe.
	Para utilizarlo seguir las instrucciones contenidas en README.txt dentro de la carpeta Compilador.

3-Debugger
	Permite debuggear un programa cargado en la FPGA. Provee una interfaz grafica amigable donde se puede
	comprobar el estado de cada etapa del pipeline, los registros y la secuencia de instrucciones ejecutadas.
	Para su utilizacion seguir las instrucciones en el archivo README.txt dentro de la carpeta MIcomPS.

4-Testing
	Test Bench
	Se crearon dos test bench, uno para testear el modulo pipeline y otro para testear el trabajo completo.
	System test
	Se crearon cuatro test de sistema para verificar la correcta ejecucion de todas las instrucciones implementadas,
	asi como tambien el correcto manejo de los hazards que se puedan presentar. Para correr tests del sistema, leer
	README.txt de la carpeta System_test
	


