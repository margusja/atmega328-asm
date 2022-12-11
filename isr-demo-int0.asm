.include "m328pdef.inc"

.cseg			;  compiler switch to the code section
.org 	0x0000		
	jmp 	setup

; memory location External Interrupt Request 0 (pin D2)
.org 0x0002
    	jmp 	INT0_ISR

setup:
	sts	EIMSK,	R16
	ldi	R16,	(1<<PINB4)|(1<<PINB5) 	; external pull down resistors must be in installed
	out 	DDRB, 	R16
	cbi	PORTB,	PINB4	
	ldi	R17,	(1<<ISC00)	; The rising edge of INT0 generates an interrupt request
	sts	EICRA,	R17
	ldi	R18,	(1<<INT0)
	out	EIMSK,	R18
	sei
	rjmp	loop
 
INT0_ISR:
	in 	r16, 	PORTB
        ldi 	r17, 	$FF
        eor 	r16, 	r17
        out 	PORTB, 	r16

	reti

loop:
	sbi	PORTB,PINB5
	rjmp 	loop
