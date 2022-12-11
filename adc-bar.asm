.include "m328pdef.inc"

.cseg			;  compiler switch to the code section
.org 	0x0000		
	jmp 	setup

.org 	0x002A
	jmp	ADC_vect

setup:
	; start configuration

	; clear ADCSRA and ADCSRB
	ldi 	R16,0b00000000
	sts	ADCSRA,R16
	sts	ADCSRB,R16

	; Using AVCC 
	; Using A5 as an input
	ori	R16,(1<<REFS0)|(1<<ADLAR)
	sts	ADMUX,R16

	; enable ADC
	; set clock prescale 16
	ldi	R16,(1<<ADEN)|(1<<ADATE)|(1<<ADIE)
	sts	ADCSRA,R16

	; one capture event
	;ldi 	R16,(1<<ADTS2)|(1<<ADTS1)|(1<<ADTS0)
	;sts     ADCSRB,R16

	; set all PORTD pins as output for storing ADCH 8 bit data
	ldi	R16,0b11111111
	out 	DDRD, R16

	; start polling
	ori     R16,(1<<ADSC)
	sts     ADCSRA,R16

	sei
	; end of configuration



; 256\8 = 32
; laed scale values:
; 256 | 224 | 192 | 160 | 128 | 96 | 64 | 32 | 0
loop:
	cpi	r16, 0b00000000		; r16 = 0
	breq	set_0 			; all leds off
	cpi	r16, 0b00100001 	; r16 > 33 (32+1) 
	brlo	set_1 			; led 1 on
	cpi	r16, 0b01000001 	; r16 > 65 (64+1)
	brlo	set_2 			; leds 2, 1 on
	cpi	r16, 0b01100001 	; r16 > 97 (96+1)
	brlo	set_3 			; leds 3, 2, 1 on
	cpi	r16, 0b10000001 	; r16 > 129 (128+1)
	brlo	set_4			; leds 4,3,2,1 on
	cpi	r16, 0b10100001 	; r16 > 161 (160+1)
	brlo	set_5			; leds 5,4,3,2,1 on
	cpi	r16, 0b11000001		; r16 > 193 (192+1)
	brlo	set_6			; leds 6,5,4,3,2,1 on
	cpi	r16, 0b11100001		; r16 > 225 (224+1)
	brlo	set_7			; leds 7,6,5,4,3,2,1 on
	cpi	r16, 0b11110001		; r16 > 241 (240+1)
	brlo	set_8			; all leds on
	rjmp	loop		; infinite loop	

set_0:
	ldi	r17,0b00000000
	out	PORTD,r17
	rjmp 	loop

set_1:
	ldi	r17,0b00000001
	out	PORTD,r17
	rjmp 	loop

set_2:
	ldi	r17,0b00000011
	out	PORTD,r17
	rjmp	loop

set_3:
	ldi	r17,0b00000111
	out	PORTD,r17
	rjmp	loop

set_4:
	ldi	r17,0b00001111
	out	PORTD,r17
	rjmp	loop

set_5:
	ldi	r17,0b00011111
	out	PORTD,r17
	rjmp	loop

set_6:
	ldi	r17,0b00111111
	out	PORTD,r17
	rjmp	loop

set_7:
	ldi	r17,0b01111111
	out	PORTD,r17
	rjmp	loop

set_8:
	ldi	r17,0b11111111
	out	PORTD,r17
	rjmp	loop

ADC_vect:
	; read result
	lds     R16,ADCH
	
	reti

