main:          
    ldi r16, 0xFF     
    out DDRB, r16
	out DDRA, r16

main_loop:

	rcall luzLabel
	rcall movLabel
	rcall xLabel
	rcall yLabel
	rcall buttonLabel
	rcall pressureLabel

	rjmp main_loop

;#####################################################################################
;                                    JOYSTICK
;#####################################################################################
;-------------------------------------------------------------------------------------
;                                DETECCIÓN EJE X
;-------------------------------------------------------------------------------------
xLabel:
	clr r16
	ldi r16, 0b01000000
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_xLabel
	ret

read_xLabel:
	clr r17
	lds r17, ADCSRA
	sbrc r17, ADSC
	rjmp read_xLabel


	clr r24
	lds r18, ADCL
	lds r19, ADCH
	ldi r24, 0x00
	cpse r18, r24
	rjmp compara_der
	rjmp compara_izq
	ret

compara_der:
	ldi r20, 0xff
	ldi r21, 0x02
	cpse r18, r20
	ret
	cp r19, r21
	brsh prende_derecha
	ret

compara_izq:
	ldi r22, 0x00
	cpse r18, r22
	ret
	cpse r19, r22
	ret
	rjmp prende_izquierda
	ret

prende_derecha:
	cbi porta, 4
	sbi porta, 2
	sbi porta, 3
;	rcall delay
;	cbi porta, 2
	ret

prende_izquierda:
	cbi porta, 2
	sbi porta, 3
	sbi porta, 4
;	rcall delay
;	cbi porta, 3
	ret
;-------------------------------------------------------------------------------------
;                                DETECCIÓN EJE Y
;-------------------------------------------------------------------------------------
yLabel:
	clr r16
	ldi r16, 0b01000001
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_yLabel
	ret

read_yLabel:
	clr r17
	lds r17, ADCSRA
	sbrc r17, ADSC
	rjmp read_yLabel

	clr r24
	lds r18, ADCL
	lds r19, ADCH
	ldi r24, 0x00
	cpse r18, r24
	rjmp compara_aba
	rjmp compara_arr
	ret

compara_aba:
	ldi r20, 0xff
	ldi r21, 0x02
	cpse r18, r20
	ret
	cp r19, r21
	brsh prende_abajo
	ret


compara_arr:
	ldi r22, 0x00
	cpse r18, r22
	ret
	cpse r19, r22
	ret
	rjmp prende_arriba
	ret

prende_arriba:
	cbi porta, 3 ; |
	sbi porta, 4 ; combinación RGB
	sbi porta, 2 ; |
;	rcall delay
;	cbi porta, 4
	ret

prende_abajo:
	cbi porta, 2
	cbi porta, 4
	cbi porta, 3
;	rcall delay
;	cbi porta, 3
	ret
;-------------------------------------------------------------------------------------
;                                DETECCIÓN BOTÓN
;-------------------------------------------------------------------------------------
buttonLabel:
	clr r16
	ldi r16, 0b01000010
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_buttonLabel
	ret

read_buttonLabel:
	clr r17
	lds r17, ADCSRA
	sbrc r17, ADSC
	rjmp read_buttonLabel

	lds r18, ADCL
	lds r19, ADCH
	ldi r24, 0x00
	cpse r18, r24
	rjmp compara_npre
	rjmp compara_pre
	ret

compara_npre:
	ldi r20, 0xff
	ldi r21, 0x03
	cpse r18, r20
	ret
	cpse r19, r21
	ret

compara_pre:
	ldi r22, 0x00
	cpse r18, r22
	ret
	cpse r19, r22
	ret
	rjmp prende_medio
	ret

prende_medio:
	sbi portb, 4
	rcall delay
	cbi portb, 4
	ret
;#####################################################################################
;                                 SENSOR MOVIMIENTO
;#####################################################################################
;-------------------------------------------------------------------------------------
;                              DETECCIÓN MOVIMIENTO
;-------------------------------------------------------------------------------------	
movLabel:
	clr r16
	ldi r16, 0b01000011
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_movLabel

read_movLabel:
	clr r23
	lds r23, ADCSRA
	sbrc r23, ADSC
	rjmp read_movLabel
	
	lds r18, ADCL
	lds r19, ADCH
	rjmp compara_mov
	
compara_mov:
	ldi r21, 0x02
	cp r19, r21
	brsh prende_mov
	ret     

prende_mov:
	rcall mueve_motor_atras      
    ret  
;#####################################################################################
;                                 SENSOR DE LUZ
;#####################################################################################
;-------------------------------------------------------------------------------------
;                                DETECCIÓN LUZ
;-------------------------------------------------------------------------------------
luzLabel:
	clr r16
	ldi r16, 0b01000100
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_luzLabel
	ret

read_luzLabel:
	clr r17
	lds r17, ADCSRA
	sbrc r17, ADSC
	rjmp read_luzLabel

	lds r18, ADCL
	lds r19, ADCH
	rjmp compara_luz

compara_luz:
	ldi r21, 0x02
	ldi r22, 0x00
	cp r19, r21
	brsh prende_luz
	cpse r18, r22
	call apaga_luz
	ret 
	
prende_luz:
    sbi PORTB, 6   
    ret  

apaga_luz:
    cbi PORTB, 6    
    ret
;#####################################################################################
;                                 SENSOR DE PRESIÓN
;#####################################################################################
pressureLabel:
	clr r16
	ldi r16, 0b010000101
	sts ADMUX, r16
	clr r16
	ldi r16, 0b11000111
	sts ADCSRA, r16
	rcall read_pressureLabel
	ret	

read_pressureLabel:
	clr r16
	clr r17
	lds r17, ADCSRA
	sbrc r17, ADSC
	rjmp read_pressureLabel

	lds r17, ADCL
	lds r16, ADCH
	rcall comparaPresion

comparaPresion:
	ldi r22, 0x0f
	ldi r23, 0x00
	;cpse r17, r22
	;ret
	cp r17, r22
	brsh prende_encima
	ret

prende_encima:
	rcall mueve_motor_adelante      
    ret  
;#####################################################################################
;                                CONFIGURACIÓN MOTOR
;#####################################################################################
mueve_motor_adelante:
	sbi ddre, 3
	ldi r21, 0x82
	sts TCCR3A, r21
	ldi r21, 0x1A
	sts TCCR3B, r21

	ldi r20, 0x01
	sts ICR3H, r20
	ldi r21, 0xF4
	sts ICR3L, r21

	ldi r20, 0x00
	sts OCR3AH, r20
	ldi r21, 0x80
	sts OCR3AL, r21

	rcall adelante
	rcall parar
	ret

mueve_motor_atras:

	sbi ddre, 3
	ldi r21, 0x82
	sts TCCR3A, r21
	ldi r21, 0x1A
	sts TCCR3B, r21

	ldi r20, 0x01
	sts ICR3H, r20
	ldi r21, 0xF4
	sts ICR3L, r21

	ldi r20, 0x00
	sts OCR3AH, r20
	ldi r21, 0x80
	sts OCR3AL, r21

	rcall atras
	rcall parar
	ret
;#####################################################################################
;                                 RUTINAS DE MOVIMIENTO
;#####################################################################################
adelante:
	sbi porta, 0
	cbi porta, 1
	rcall delay_subebaja
	cbi porta, 0  
	cbi porta, 1
	ret
atras:
	sbi porta, 1
	cbi porta, 0
	rcall delay_subebaja
	cbi porta, 1 
	cbi porta, 0 
	ret
parar:
	sbi porta, 0
	cbi porta, 0
	rcall delay_subebaja
	cbi porta, 0 
	cbi porta, 0 
	ret 
;#####################################################################################
;                                         EXTRAS
;#####################################################################################    
;-------------------------------------------------------------------------------------
;                                DELAY PARA VER LEDS
;-------------------------------------------------------------------------------------
delay:
    ldi r20, 150
L1:
    ldi r21, 150
L2:
    ldi r22, 150
L3:
    nop
    nop
    dec r22
    brne L3
    dec r21
    brne L2
    dec r20
    brne L1
    ret 
;-------------------------------------------------------------------------------------
;                            DELAY PARA DURACIÓN DEL MOTOR
;-------------------------------------------------------------------------------------
delay_subebaja:
    ldi r20, 200
Lmotor1:
    ldi r21, 200
Lmotor2:
    ldi r22, 200
Lmotor3:
    nop
    nop
    dec r22
    brne Lmotor3
    dec r21
    brne Lmotor2
    dec r20
    brne Lmotor1
    ret
