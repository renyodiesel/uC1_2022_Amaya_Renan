;-------------------------------------------------------------------------------
    ;@file    Ejercicio_2.s
    ;@brief   Corrimientos de Leds con interrupciones 
    ;         de alta y baja prioridad(Assembly language)
    ;@date    28/01/2023
    ;@author  Amaya Ruiz Renan Esteban
    ;MPLAB X IDE v6.00
    ;Compiler: pic-ass v2.40
    ;Frecuency = 4MHz
;-------------------------------------------------------------------------------
    
    
PROCESSOR 18F57Q84
#include "Bit_Config.inc"   ;/config statements should precede project file includes./
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
 resetVect:
    goto Main

 PSECT ISRVectLowPriority,class=CODE,reloc=2
     ISRVectLowPriority:
         BTFSS          PIR1,0,0      ;¿button press? -> PIR1(bit0)=1
	 GOTO           Exit0         ;if_no 
	Go_secuencia:                 ;if_si 
	 BCF            PIR1,0,0      ;Limpiar Flag -> PIR1(bit0)=0 
	 GOTO           Carga_0     
     Exit0:
         RETFIE
    
    
 PSECT ISRVectHighPriority,class=CODE,reloc=2
     ISRVectHighPriority:
             BTFSS      PIR6,0,0      ;¿button press? -> PIR6(bit0)=1
	     GOTO       pir_10        ;if_no
	     Go_toggle:               ;if_si
                 BCF    PIR6,0,0      ;Limpiar Flag -> PIR1(bit0)=0
		 GOTO   Routine_bi
     Exit1: 
         RETFIE
    
 PSECT udata_acs
      CONTADOR1:  DS 1 ;contador de delays    
      CONTADOR2:  DS 1 ;contador de delays
      offset:     DS 1
      counter:    DS 1 ;contador de offset
      counter1:   DS 1 ;contador de 5 laps
 PSECT CODE    
      Main:
          CALL    Config_OSC,1
          CALL    Config_Port,1
          CALL    Config_PPS,1
          CALL    Config_INT0_INT1_INT2,1 
	  ;---------------------------------------------------------------------
	  GOTO    Routine_bi ; Inicializar -> Leds apagados y toggle de RF3
	     
         Carga_0:
             MOVLW 5                  ;literal de 5
	     MOVWF counter1,0         ;Cargarlo a counter1 - Contador general
	     MOVLW 0                  ;literal de 0
	     MOVWF offset,0           ;Cargarlo a offset
	     GOTO  Reload
	     
	 After_5_laps:
             DECFSZ counter1,1,0     ;Decrementar el valor del contador general y ¿Counter1=0?
	     GOTO Reload             ;if_no
	     ;GOTO Reset_m
	     GOTO Exit0              ;if_si
	 Reset_m:
             SETF  LATC,0            ;Apagar leds
	     CALL  Delay_250ms,1    
	     CALL  Delay_250ms,1
	     GOTO  Salida   
	     
	 Loop:
             BSF LATF,3,0            ;Encender led de placa -> RA3=1
             BANKSEL PCLATU
             MOVLW   low highword(table)
             MOVWF   PCLATU,1
             MOVLW   high(table)
             MOVWF   PCLATH,1
             RLNCF   offset,0,0
             CALL    table
             MOVWF   LATC,0
             CALL    Delay_250ms,1
             DECFSZ  counter,1,0    ;Decrementar contador de offset y ¿counter=0?
             GOTO    Next_Seq       ;if_no -> que siga cargando valores
             GOTO    After_5_laps   ;if_si -> termina un corrimiento
         Next_Seq:
             INCF    offset,1,0     ;incrementa el valor del offset
	     GOTO    Loop           ;regresa al loop a seguir cargando valores
	    
         Reload:
             MOVLW   10	            ;literal de 10 = 0x0A
             MOVWF   counter,0	    ;Lo cargamos al contador de offsets
             MOVLW   0x00	    
             MOVWF   offset,0	    ;definimos el valor del offset inicial
             GOTO    Loop
	     
	 pir_10:
             BTFSS   PIR10,0,0      ;¿button press? -> PIR10(bit0)=1
             GOTO    Exit1          ;if_no
	     ;if_si
             BCF    PIR10,0,0       ;Limpiar Flag -> PIR10(bit0)=0
	     GOTO   Reset_m         ;Apagar LEDS -> LATC=1
          
	 Routine_bi:
             BTFSC  PORTF,2,0
	     BTG    LATF,3,0
	     BTFSC  PORTF,2,0
	     CALL   Delay_250ms,1
	     BTFSC  PORTF,2,0
	     CALL   Delay_250ms,1
	     BTFSC  PORTF,2,0
	     GOTO   Routine_bi
	     GOTO   pir_10
     
 ;------------------------------------------------------------------------------
 ;Configuraciones,retardo y tabla 
 ;------------------------------------------------------------------------------
  Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
   ;---------------------------------------------------------------------------- 
 Config_Port:	
     ;Configuracion LED placa -> RF3
     BANKSEL PORTF
     CLRF PORTF,1
     BSF  LATF,3,1
     CLRF ANSELF,1
     BCF  TRISF,3,1
     ;Config Boton placa -> RA3 = INT0
     BANKSEL PORTA
     CLRF    PORTA,1	 ;PORTA         = 0
     CLRF    ANSELA,1	 ;ANSELA        = 0 --> Digital
     BSF     TRISA,3,1	 ;TRISA (bit 3) = 1 --> Entrada
     BSF     WPUA,3,1    ;WPUA (bit 3)  = 1 --> R pull-up enable
    
     ;Config Boton RB4 = INT1
     BANKSEL PORTB       
     CLRF    PORTB,1	 ;PORTA         = 0
     CLRF    ANSELB,1	 ;ANSELA        = 0 --> Digital
     BSF     TRISB,4,1	 ;TRISA (bit 3) = 1 --> Entrada
     BSF     WPUB,4,1    ;WPUA (bit 3)  = 1 --> R pull-up enable
    
     ;Config Boton RF2 = INT2
     BANKSEL PORTF
     CLRF    PORTF,1	 ;PORTA         = 0
     CLRF    ANSELF,1	 ;ANSELA        = 0 --> Digital
     BSF     TRISF,2,1	 ;TRISA (bit 3) = 1 --> Entrada
     BSF     WPUF,2,1    ;WPUA (bit 3)  = 1 --> R pull-up enable
    
     ;Config PORTC (Leds)
     BANKSEL PORTC
     SETF    PORTC,1	 ;PORTC         = 0
     SETF    LATC,1	 
     CLRF    ANSELC,1	 ;ANSELC        = 0 --> Digital
     CLRF    TRISC,1     ;TRISC         = 1 --> Salida
     RETURN
   ;---------------------------------------------------------------------------- 
    Config_PPS:
    ;Config INT0     
     BANKSEL INT0PPS
     MOVLW   0x03 
     MOVWF   INT0PPS,1	 ; INT0 --> RA3 --> low prioirity
    
     ;Config INT1
     BANKSEL INT1PPS
     MOVLW   0x0C
     MOVWF   INT1PPS,1	 ; INT1 --> RB4 --> high priority
    
     ;Config INT2
     BANKSEL INT2PPS
     MOVLW 0X2A
     MOVWF INT2PPS,1      ; INT2 --> RF2 -->high priority
     RETURN
   ;---------------------------------------------------------------------------- 
   ;   Secuencia para configurar interrupcion:
   ;    1. Definir prioridades
   ;    2. Configurar interrupcion
   ;    3. Limpiar el flag
   ;    4. Habilitar la interrupcion
   ;    5. Habilitar las interrupciones globales
  
  Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0  ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1     ; IPR1<INT0IP>     = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1     ; IPR6<INT1IP>     = 1 -- INT1 de alta prioridad
    BSF IPR10,0,1    ; IPR10<INT2P>     = 1 -- INT2 de alta prioridad
    
    
    ;Config INT0
    BCF	INTCON0,0,0  ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0     ; PIR1<INT0IF>     = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0     ; PIE1<INT0IE>     = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0  ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0     ; PIR6<INT0IF>     = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0     ; PIE6<INT0IE>     = 1 -- habilitamos la interrupcion ext1
     
    ;Config INT2
    BCF	INTCON0,2,0  ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT0IF>    = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT0IE>    = 1 -- habilitamos la interrupcion ext2
     
    ;Global Interrupt Enable -- Global Low Interrupt Enable
    BSF	INTCON0,7,0  ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0  ; INTCON0<GIEL>     = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
  ;-----------------------------------------------------------------------------  
 table:
      ADDWF   PCL,1,0
      RETLW   01111110B	; offset: 0
      RETLW   10111101B	; offset: 1
      RETLW   11011011B	; offset: 2
      RETLW   11100111B	; offset: 3
      RETLW   11111111B	; offset: 4
      RETLW   11100111B	; offset: 5
      RETLW   11011011B	; offset: 6
      RETLW   10111101B	; offset: 7
      RETLW   01111110B	; offset: 8
      RETLW   11111111B	; offset: 9
  ;-----------------------------------------------------------------------------    
 Delay_250ms:                          ;  1 Call ---> 2 TCY
         MOVLW  250                    ;  MOVLW  ---> 1 TCY --->k2
         MOVWF  CONTADOR2,0            ;  MOVWF  ---> 1 TCY
         ; t = (6+4k1)us
         Con_ext_250ms:  
             MOVLW  249                ;  k2*TCY -->k1
             MOVWF  CONTADOR1,0        ;  k2*TCY
         Con_int_250ms:
             Nop                       ;  k2*k1*TCY
             DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*Tcy)
             GOTO   Con_int_250ms      ;  k2((k1-1)*2TCY)
             DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
             GOTO   Con_ext_250ms      ;  (k2-1)*2TCY
             RETURN                    ;  2*TCY
         Salida:
             END resetVect

