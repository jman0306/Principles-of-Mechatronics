//--------------------------
// Assembly Code
//--------------------------

#define _SFR_OFFSET 0x00
#include "avr/io.h"

//--------------------------

.global START
.equ ddra, 0x01
.equ porta, 0x02
.equ ddrb, 0x04
.equ portb, 0x05
.equ pinc, 0x06
.equ ddrc, 0x07
.equ portc, 0x08     ; Correctly defined portc
.equ pinf, 0x0F
.equ ddrf, 0x10
.equ tifr0, 0x15
.equ tccr0a, 0x24
.equ tccr0b, 0x25
.equ tcnt0, 0x26

//--------------------------

START:
  LDI R20, 0xFF      ;
  LDI R21, 0x00      ;
  
  OUT ddra, R20      ;
  OUT ddrb, R20      ;
  OUT ddrf, R21      ; 
  SBI porta, 2       ; prendo rojo no prioritario
  SBI portb, 7       ; prendo verde prioritario
 
PRINCIPAL:
  IN r16, pinc       ; guardo todo el puerto C en r16
  SBRC r16, 0        ;
  CALL COCHE1        ;    
  SBRC r16, 1        ;
  CALL COCHE2        ;
  SBRC r16, 2        ;
  CALL COCHE3        ;
  SBRC r16, 3        ;
  CALL COCHE4        ;
  SBRC r16, 4        ;
  CALL COCHE5        ;
  LDI R17, 20        ; 20 veces base = 3 segundos
  LOOP3: 
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP3       ; 
  RJMP PRINCIPAL

BASE:                ; base de tiempo de 0.15 segundos 
  LDI R22, 9         ;
  LOOP:
    LDI R18, 0x05    ;
    OUT tcnt0, R21   ;
    OUT tccr0a, R21  ;
    OUT tccr0b, R18  ;
    AGAIN:
      IN R20, tifr0  ;
      SBRS R20, 0    ;
      RJMP AGAIN     ;
      OUT tccr0b, R21;
      LDI R20, 0x01  ;
      OUT tifr0, R20 ;
      DEC R22        ;  
      BRNE LOOP      ;
      RET

AMARILLO_P:
  CBI portb, 7       ; apago verde prioritario
  SBI portb, 6       ; prende amarillo prioritario
  LDI R17, 5         ; 5 veces base = 0.75 segundos
  LOOP75:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP75      ;
  CBI portb, 6       ; apago amarillo prioritario
  SBI portb, 5       ; prendo rojo prioritario
  CBI porta, 2       ; apago rojo no prioritario
  SBI porta, 0       ; prendo verde no prioritario
  RET    

COCHE1:
  CALL AMARILLO_P    ;
  LDI R17, 4         ; 4 veces base = 0.6 segundos
  LOOP60:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP60      ;
  CBI porta, 0       ; apago verde no prioritario
  SBI porta, 1       ; prendo amarillo no prioritario
  CALL BASE          ; 0.15 segundos
  CBI porta, 1       ; apago amarillo no prioritario
  SBI porta, 2       ; prendo rojo no prioritario
  CBI portb, 5       ; apago rojo prioritario
  SBI portb, 7       ; prendo verde prioritario
  JMP PRINCIPAL      ; 


COCHE2:
  CALL AMARILLO_P    ;
  LDI R17, 8         ; 8 veces base = 1.2 segundos
  LOOP120:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP120     ;
  CBI porta, 0       ; apago verde no prioritario
  SBI porta, 1       ; prendo amarillo no prioritario
  LDI R18, 2         ; 2 veces base = 0.3 segundos
  LOOP30:
    CALL BASE        ;
    DEC R18          ;
    BRNE LOOP30      ;
  CBI porta, 1       ; apago amarillo no prioritario
  SBI porta, 2       ; prendo rojo no prioritario
  CBI portb, 5       ; apago rojo prioritario
  SBI portb, 7       ; prendo verde prioritario
  JMP PRINCIPAL      ;

COCHE3:
  CALL AMARILLO_P    ;
  LDI R17, 12        ; 12 veces base = 1.8 segundos
  LOOP180:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP180     ;
  CBI porta, 0       ; apago verde no prioritario
  SBI porta, 1       ; prendo amarillo no prioritario
  LDI R18, 3         ; 3 veces base = 0.45 segundos
  LOOP45:
    CALL BASE        ;
    DEC R18          ;
    BRNE LOOP45      ;
  CBI porta, 1       ; apago amarillo no prioritario
  SBI porta, 2       ; prendo rojo no prioritario
  CBI portb, 5       ; apago rojo prioritario
  SBI portb, 7       ; prendo verde prioritario
  JMP PRINCIPAL      ;

COCHE4:
  CALL AMARILLO_P    ;
  LDI R17, 16        ; 16 veces base = 2.4 segundos
  LOOP240:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP240     ;
  CBI porta, 0       ; apago verde no prioritario
  SBI porta, 1       ; prendo amarillo no prioritario
  LDI R18, 4         ; 4 veces base = 0.6 segundos
  LOOP602:
    CALL BASE        ;
    DEC R18          ;
    BRNE LOOP602     ;
  CBI porta, 1       ; apago amarillo no prioritario
  SBI porta, 2       ; prendo rojo no prioritario
  CBI portb, 5       ; apago rojo prioritario
  SBI portb, 7       ; prendo verde prioritario
  JMP PRINCIPAL      ;
    
  COCHE5:
  CALL AMARILLO_P    ; 
  LDI R17, 20        ; 20 veces base = 3 segundos
  LOOP300:
    CALL BASE        ;
    DEC R17          ;
    BRNE LOOP300     ;
  CBI porta, 0       ; apago verde no prioritario
  SBI porta, 1       ; prendo amarillo no prioritario
  LDI R18, 5         ; 5 veces base = 0.75 segundos
  LOOP752:
    CALL BASE        ;
    DEC R18          ;
    BRNE LOOP752     ;
  CBI porta, 1       ; apago amarillo no prioritario
  SBI porta, 2       ; prendo rojo no prioritario
  CBI portb, 5       ; apago rojo prioritario
  SBI portb, 7       ; prendo verde prioritario
  JMP PRINCIPAL      ;

;---------------------
