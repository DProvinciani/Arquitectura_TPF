REQUERIMIENTOS

    - Python 2.7
    - Modulos: Los siguientes modulos necesarios pueden ser instalados haciendo uso de PIP.
                pyserial
                bitstring
    - Libreria wxPython 2.8



INSTRUCCIONES PARA EL USO DE MIcomPS

1)  Ejecutar mediante el interprete de Python el archivo MIcomPS.py
2)  En el menu emergente seleccionar el puerto serial al que se encuentra conectada la placa FPGA Digilent NEXIS 3
    y seleccionar como velocidad de transmision de simbolos 19200 baudios. Deje desmarcados los items RTS/CTS y
    Xon/Xoff.
3)  En la interfaz principal potra hacer uso de las siguientes 3 funcionalidades:
        a- Mediante el boton "CLOCK", indicar a la placa que ejecute la siguiente instruccion del programa.
        b- Mediante el boton "RUN", indicar a la placa que ejecute todas las instrucciones del programa.
        c- Mediante el boton "UPDATE FIELDS" refrescar los datos desplegados por la interfaz a los valores actuales.

NOTA: - Si desea reconfigurar el puerto serial a utilizar, puede hacer uso del boton "SETTINGS" para acceder al menu
        emergente.
      - Todas las funcionalidades pueden ser accedidas tambien desde los menu desplegables.
      - Puede hacer uso de atajos de teclado para acceder a todas las funcionalidades. Los mismos se encuentran
        especificados en ya ayuda del programa.