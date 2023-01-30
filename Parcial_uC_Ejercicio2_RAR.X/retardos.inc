;---------------------------------------------------
    ;@file    delays_k.inc
    ;@brief   Header file of delays (Assembly language)
    ;@date    07/01/2023
    ;@author  Amaya Ruiz Renan Esteban
    ;MPLAB X IDE v6.00
    ;Compiler: pic-ass v2.40
    ;Frecuency = 4MHz
;---------------------------------------------------
PSECT udata_acs
CONTADOR1: DS 1      ;Por access ram
CONTADOR2: DS 1      ;Por access ram
  
PSECT code

; Frecuency = 4MHz ----> 1 TCY-> 1us
; t = tiempo
 
; Delay_1--->10us
; t = (6+4k1)*TCY  
Delay_10us:                  ;  1 Call ---> 2 TCY
    MOVLW  1                 ;  MOVLW  ---> 1 TCY
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_10us:   
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ;  (k1-1) + 3*TCY
    GOTO   Con_10us          ;  (k1-1)*2TCY
    RETURN                   ;   2*TCY
    
    
; Delay_2_25us
; t = (6+4k1)*TCY 
Delay_25us:                  ;  1 Call ---> 2 TCY
    MOVLW  5                 ;  MOVLW  ---> 1 TCY
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_25us:   
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ;  (k1-1) + 3*TCY
    GOTO   Con_25us          ;  (k1-1)*2TCY
    RETURN                   ;  2*TCY
    
    
; Delay_3-->50us
; t = (6+4k1)*TCY   
Delay_50us:                  ;  1 Call ---> 2 TCY
    MOVLW  11                ;  MOVLW  ---> 1 TCY
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_50us:
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ;  (k1-1) + 3*TCY
    GOTO   Con_50us          ;  (k1-1)*2TCY
    RETURN                   ;  2*TCY
                                  
                                  
; Delay_4-->100us           
; t = (6+4k1)*TCY  
Delay_100us:                 ;  1 Call ---> 2 TCY
    MOVLW  24                ;  MOVLW  ---> 1 TCY
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_100us:
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ;  (k1-1) + 3*TCY
    GOTO   Con_100us         ;  (k1-1)*2TCY
    RETURN                   ;  2*TCY

      
; Delay_5-->200us
; t = (6+4k1)*TCY  
Delay_200us:                 ;  1 Call ---> 2 TCY
    MOVLW  49                ;  MOVLW  ---> 1 TCY
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_200us:
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ; (k1-1) + 3*TCY
    GOTO   Con_200us         ; (k1-1)*2TCY
    RETURN                   ;  2TCY

 
; Delay_6-->250us
; t = (6+4k1)*TCY  
Delay_250us:                 ;  1 Call ---> 2 TCY
    MOVLW  61                ;  MOVLW  ---> 1 TCY 
    MOVWF  CONTADOR1,0       ;  MOVWF  ---> 1 TCY
Con_250us:
    NOP                      ;  k1*TCY
    DECFSZ CONTADOR1,1,0     ;  (k1-1) + 3*TCY
    GOTO   Con_250us         ;  (k1-1)*2TCY
    RETURN                   ;  2TCY

    
; Delay_7-->500us
; t = (6+4k1)*TCY 
Delay_500us:                 ;   1 Call ---> 2 TCY
    MOVLW  124               ;   MOVLW  ---> 1 TCY 
    MOVWF  CONTADOR1,0       ;   MOVWF  ---> 1 TCY
Con_500us:
    NOP                      ;   k2*k1*TCY
    DECFSZ CONTADOR1,1,0     ;   (k1-1) + 3*TCY
    GOTO   Con_500us         ;   (k1-1)*2TCY
    RETURN                   ;   2*TCY
    
    
; Delay_8-->1ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+ k2*(1us)+ 6us     
Delay_1ms:                    ;  1 Call ---> 2 TCY
    MOVLW  1                  ;  MOVLW  ---> 1 TCY  --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us = 1ms 
C_ext_1ms:  
    MOVLW  249                ;  k2*TCY --->k1
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_1ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_1ms          ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_1ms          ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY

  
; Dely_9-->5ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+ k2*(1us)+ 6us  
Delay_5ms:                    ;  1 Call ---> 2 TCY
    MOVLW  5                  ;  MOVLW  ---> 1 TCY----->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us
C_ext_5ms:  
    MOVLW  249                ;  k2*TCY---->k1
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_5ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_5ms          ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_5ms          ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY
    
    
; Delay_10-->10ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+k2*(1us)+ 6us
Delay_10ms:                   ;  1 Call ---> 2 TCY
    MOVLW  10                 ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us 
C_ext_10ms:  
    MOVLW  249                ;  k2*TCY ---> k1
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_10ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_5ms          ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_5ms          ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY
    
   
; Delay_11-->25ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+k2*(1us)+ 6us 
Delay_25ms:                   ;  1 Call ---> 2 TCY
    MOVLW  25                 ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us
C_ext_25ms:  
    MOVLW  249                ;  k2*TCY --->k1
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_25ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_25ms         ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_25ms         ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY
    
    
; Delay_12-->50ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+k2*(1us)+ 6us 
Delay_50ms:                   ;  1 Call ---> 2 TCY
    MOVLW  50                 ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)ua= (6+4*(249))= 1ms 
C_ext_50ms:  
    MOVLW  249                ; k2*TCY --->k1
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_50ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_5ms          ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_50ms         ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY  
                                  
                                   
; Delay_13-->100ms            
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+ k2*(1us)+ 6us 
Delay_100ms:                  ;  1 Call ---> 2 TCY
    MOVLW  100                ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us
C_ext_100ms:                          
    MOVLW  249                ;  k2*TCY --->k1=249
    MOVWF  CONTADOR1,0        ;  k2*TCY
C_int_100ms:                            
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_100ms        ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_100ms        ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY
   
    
; Delay_14-->200ms
; t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+ k2*(1us)+ 6us 
Delay_200ms:                  ;  1 Call ---> 2 TCY
    MOVLW  200                ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
; t = (6+4k1)us
C_ext_200ms:  
    MOVLW  249                ;  k2*TCY --->k1=249
    MOVWF  CONTADOR1,0        ;  k2*TCU
C_int_200ms:
    Nop                       ;  k2*k1*TCY
    DECFSZ CONTADOR1,1,0      ;  k2*((k1-1) + 3*TCY)
    GOTO   C_int_200ms        ;  k2((k1-1)*2TCY)
    DECFSZ CONTADOR2,1,0      ;  (k2-1) + 3*TCY
    GOTO   C_ext_200ms        ;  (k2-1)*2TCY
    RETURN                    ;  2*TCY
    
    
; Delay_15-->250ms
;t = (k2*(6+4(k1)us))+k2*(1us)+ 6*(1us)= (k2*(6+4(249)us))+ k2*(1us)+ 6us
Delay_250ms:                  ;  1 Call ---> 2 TCY
    MOVLW  250                ;  MOVLW  ---> 1 TCY --->k2
    MOVWF  CONTADOR2,0        ;  MOVWF  ---> 1 TCY
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



