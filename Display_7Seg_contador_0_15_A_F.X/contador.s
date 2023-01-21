;--------------------------------------------------------------------------
    ;@file    contador.s
    ;@brief   contador del 0_15 y de A_F(Assembly language)
    ;@date    15/01/2023
    ;@author  Amaya Ruiz Renan Esteban
    ;MPLAB X IDE v6.00
    ;Compiler: pic-ass v2.40
    ;Frecuency = 4MHz
    ;Display de 7 Seg A_com
;------------------------------------------------------------------------- 
PROCESSOR 18F57Q84
#include "configuracion_bits.inc"
#include <xc.inc>
#include "retardos.inc"
    
PSECT resetVect, class=code, reloc=2
resetVect: 
    goto Main

PSECT CODE
Main:
    CALL config_osc,1
    CALL config_port,1
    
boton:
    BTFSC   PORTA,3,0
    goto    numeros
;tener en cuenta que es un display de anodo comun
;por lo tanto necesitamos un 0 en las salidas para
;encenderlo
    
letras:
    ; el boton debe estar presionado para que muestre letras
 
  Letra_A:
    MOVLW   10001000B      ;ingresamos un literal en forma binaria    
    BANKSEL PORTD
    MOVWF   PORTD,1        ;lo cargamos al portd
    CALL    Delay_250ms,1  ;delay pedido
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0     ;¿boton presionado = 0? 
    goto numeros          ;if_no = va a subrutina numeros
  Letra_B:                ;if_si = sigue mostrando letras
    MOVLW   10000011B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    goto    numeros
  Letra_C:
    MOVLW   11000110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    goto    numeros
  Letra_D:
    MOVLW   10100001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    goto numeros
  Letra_E:
    MOVLW   10000110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    goto numeros
  Letra_F:
    MOVLW   10001110B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1 
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    goto    numeros
    goto    Letra_A
  
numeros:
    ;el boton no debe estar presionado para que muestre numeros
 
  cero:
    MOVLW   11000000B        ;ingresamos literla en forma binaria
    BANKSEL PORTD
    MOVWF   PORTD,1          ;los cargamos al portd
    CALL    Delay_250ms,1    ;delay pedido
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0       ;boton no presiondo = 1?
    goto letras             ;if_no = va a subrutina letras
  uno:                      ;if_si = sigue mostrando numeros
    MOVLW   11111001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  dos:
    MOVLW   10100100B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  tres:
    MOVLW   10110000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  cuatro:
    MOVLW   10011001B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  cinco:
    MOVLW   10010010B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  seis:
    MOVLW   10000010B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
   BTFSS   PORTA,3,0
    goto letras
  siete:
    MOVLW   11111000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0
    goto letras
  ocho:
    MOVLW   10000000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
   BTFSS   PORTA,3,0
    goto letras
  nueve:
    MOVLW   10011000B
    BANKSEL PORTD
    MOVWF   PORTD,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    CALL    Delay_250ms,1
    BTFSS   PORTA,3,0; si preionamos PORA=0
    goto letras
    goto  cero
    
config_osc:  
    BANKSEL OSCCON1
    MOVLW   0x60 
    MOVWF   OSCCON1,1
    MOVLW   0x02 
    MOVWF   OSCFRQ,1
    RETURN
    
config_port:
    ; salidas para el display
    BANKSEL PORTD   
    CLRF    PORTD,1	;PORTD=0
    CLRF    LATD,1	;LATD=1, Leds apagado
    CLRF    ANSELD,1	;ANSELD=0, Digital
    CLRF    TRISD,1     ;puerto  D como salidas
    ;push button
    BANKSEL PORTA
    CLRF    PORTA,1	;
    CLRF    ANSELA,1	;ANSELA=0, Digital
    BSF	    TRISA,3,1	; TRISA=1 -> entrada
    BSF	    WPUA,3,1	;Activo la reistencia Pull-Up
    RETURN      
    
END resetVect


