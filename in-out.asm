	.include "m328pdef.inc"

	.cseg
	.org 	0x00
	ldi	r16,0b00100000
	out	DDRB,r16
	sbi	PORTB,0
	sbi	PORTB,1

loop1:
	sbic 	PINB,0
	rjmp	loop1
	rjmp	led_on			; jump to led_on method

loop2:
	sbic 	PINB,1
	rjmp	loop2			; stay in infinite loop
	rjmp 	led_off			; jump to led_of method

led_on:
	sbi     PORTB,5 
	rjmp loop2
led_off:
	sbi     PORTB,5 
	rjmp 	loop1
