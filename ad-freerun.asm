.include "m328pdef.inc"

.cseg			;  compiler switch to the code section
.org 	0x00		

start:

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
ldi	R16,(1<<ADEN)|(1<<ADPS2)
sts	ADCSRA,R16

; one capture event
ldi 	R16,(1<<ADTS2)|(1<<ADTS1)|(1<<ADTS0)
sts     ADCSRB,R16

; set all PORTD pins as output for storing ADCH 8 bit data
ldi	R16,0b11111111
out 	DDRD, R16

; end of configuration

; start polling
ori	R16,(1<<ADSC)
sts	ADCSRA,R16

loop:
	lds	r16,ADCSRA
	sbrs 	r16,ADIF
	rjmp 	loop		; AD conversion is still progress jump back to loop
	lds	R16,ADCH
	out	PORTD,R16
	rjmp	start		; infinite loop	

