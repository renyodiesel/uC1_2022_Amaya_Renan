;--------------------------------------------------------------------------
    ;@file    corrimientos.s
    ;@brief   corriemientos de Leds pares e impares(Assembly language)
    ;@date    15/01/2023
    ;@author  Amaya Ruiz Renan Esteban
    ;MPLAB X IDE v6.00
    ;Compiler: pic-ass v2.40
    ;Frecuency = 4MHz
;-------------------------------------------------------------------------
PROCESSOR 18F57Q84
#include"configuracion_bits.inc"
#include <xc.inc>
#include"retardos.inc"
PSECT inicio, class=CODE, reloc=2
    GOTO Main

PSECT CODE
Main:
CALL config_osc,1
CALL config_port,1 
 inicio: 
    BTFSC   PORTA,3,0          ;  ¿boton presionado if_Si= 0?
    GOTO    rutina_de_inicio  
  corrimiento_par:
    BCF     LATE,0,1           ;apagamos el led indicador contrario
    MOVLW   1
    MOVWF   0X502,a            ;el literal 1 va al registro 502 
   loop:
    RLNCF   0x502,f,a          ;hacemos rotaciones con el valor anteriormente guardado
    MOVF    0X502,w,a          ;lo llevamos al acumulador
    BANKSEL PORTC              ;seleccionamos el registro de portc
    MOVWF   PORTC,1            ;cargamos el valor del acumulador al registro portc
    BSF     LATE,1,1           ;prendemos el led indicador
    CALL    Delay_250ms,1      ;delay pedido
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0          ;¿boton presionado = 0?        ; 
    GOTO    despues_1          ;if_si ->continua la rutina
    GOTO    stop_1             ;if_no ->el corrimiento debe detenerse
    
   despues_1:
    BTFSC   0x502,7,0          ;analiza el MSB  bit(7)=0 
    GOTO    corrimiento_impar  ;if_no=corrimiento impar
    RLNCF   0x502,f,a          ;if_si=sigue con los corrimietntos 
    MOVF    0X502,w,a
    GOTO    loop               ;regresa al loop
    
   
    
  corrimiento_impar:
    BCF     LATE,1,1
    MOVLW   1
    MOVWF   0X502,a
  
   LOPP2:
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,0,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0         
    GOTO    despues_2
    GOTO    stop_2
   despues_2:
    BTFSC   0x502,6,0         ;analizamos el bit(6)=0
    GOTO    corrimiento_par   ;if_no = va a corrimiento par
    RLNCF   0x502,f,a         ;if si = sigue con los corriemientos
    RLNCF   0x502,f,a
    MOVF    0X502,w,a
    GOTO    LOPP2
    ;
    
rutina_de_inicio:
    CLRF    PORTC,1
    GOTO    inicio
    
stop_1:
   RETARDO:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
   guardado_1:
    MOVF    0X502,w,a    ;movemos el valor cargado en 502 al acumulador
    BANKSEL PORTC
    MOVWF   PORTC,1      ;lo cargamos a portc
    BSF     LATE,1,1     ;encendemos el led indicador respectivo
    BTFSC   PORTA,3,0    ;¿boton presionado? 
    GOTO    guardado_1   ;if_no = sigue en el loop 
    GOTO    despues_1    ;if_si = continua con la rutina
   
stop_2:
   RETARDO2:
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
    CALL    Delay_250ms
   guardado_2: 
    MOVF    0X502,w,a
    BANKSEL PORTC
    MOVWF   PORTC,1
    BSF     LATE,0,1
    BTFSC   PORTA,3,0; si preionamos PORA=0
    GOTO    guardado_2
    GOTO    despues_2
    
  
  config_osc:  
    BANKSEL OSCCON1
    MOVLW   0x60 
    MOVWF   OSCCON1,1
    MOVLW   0x02 
    MOVWF   OSCFRQ,1
    RETURN
    
config_port:
    ;leds de corrimiento
    BANKSEL PORTC   
    CLRF    PORTC,1	;PORTC=0
    CLRF    LATC,1	;LATC=0, Leds apagado
    CLRF    ANSELC,1	;ANSELC=0, Digital
    CLRF    TRISC,1	;Todos salidas 
    ; leds indicadores
    BANKSEL PORTE   
    CLRF    PORTE,1	;PORTE=0
    BCF     LATE,0,1	;LATE=1, Leds apagado
    BCF     LATE,1,1
    CLRF    ANSELE,1	;ANSELE=0, Digital
    CLRF    TRISE,1	;Todos salidas 
    ;push button
    BANKSEL PORTA
    CLRF    PORTA,1	;
    CLRF    ANSELA,1	;ANSELA=0, Digital
    BSF	    TRISA,3,1	; TRISA=1 -> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up
    return
    END inicio


