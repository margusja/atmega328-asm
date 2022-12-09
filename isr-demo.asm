.include "m328pdef.inc"

.cseg			;  compiler switch to the code section
.org 	0x0000		
	jmp 	setup

; memory location External Interrupt Request 0 (pin D2)
.org 0x0002
    	jmp 	INT0_ISR

; memory location External Interrupt Request 1 (pin D3)
.org 0x0004
    	jmp 	INT1_ISR

setup:
	sts	EIMSK,R16
	ldi	R16,(1<<PINB4)|(1<<PINB5) 	; external pull down resistors must be in installed
	out 	DDRB, R16
	cbi	PORTB,PINB4	
	ldi	R17,(1<<ISC00)|(1<<ISC10)	; The rising edge of INT0 generates an interrupt request
	sts	EICRA,R17
	ldi	R18,(1<<INT0)|(1<<INT1)
	out	EIMSK,R18
	sei
	rjmp	loop
 
INT0_ISR:
	in r16, SREG     ; store SREG value
	cli              ; disable interrupts 
	sbi	PORTB,PINB4
	out SREG, r16    ; restore SREG value (I-bit)
	reti

INT1_ISR:
	in r16, SREG     ; store SREG value
        cli              ; disable interrupts
	cbi	PORTB,PINB4
	out SREG, r16    ; restore SREG value (I-bit)
	reti	

loop:
	sbi	PORTB,PINB5
	rjmp 	loop
