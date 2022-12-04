.include "m328pdef.inc"

.cseg
.org 	0x00

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
; set clock prescale 128
ldi	R16,(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)
sts	ADCSRA,R16

; one capture event
ldi 	R16,(1<<ADTS2)|(1<<ADTS1)|(1<<ADTS0)
sts     ADCSRB,R16

; set all PORTD pins as output for storing ADCH 8 bit data
ldi	R16,0b11111111
out 	DDRD, R16

sbi 	DDRB,5    		; Set PB5 (onboard led) as Output
sbi	DDRB,4			; DEBUG pin for ADC saveresult subroutine
cbi	PORTB,5			; turn led off
cbi	PORTB,4

; end of configuration

; start polling
ori	R16,(1<<ADSC)
sts	ADCSRA,R16

loop:
	sbi	PORTB,4 	; set pin to indicate we are in ADC loop
	lds	r16,ADCSRA
	sbrc 	r16,ADSC
	rjmp 	loop		; AD conversion is still progress jump back to loop
	rjmp	saveresult	; AD conversion is ready jump to result

saveresult:
	
	lds	R16,ADCH
	out	PORTD,R16
	rjmp	result
	
result:
	sbi	PORTB,5		; set led on arduono board pin 13 high to indicate result is ready
	rjmp	result		; infinite loop	

