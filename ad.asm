.include "m328pdef.inc"

.cseg
.org 	0x00

; start configuration

; Configure the REFS[1:0] bits to select the high reference voltage to use
; Using AVCC
cbi     ADMUX,7
sbi	ADMUX,6

sbi	ADMUX,5		;using 8 bit conversion results

; Using A5 as an input
cbi     ADMUX,3
sbi     ADMUX,2
cbi     ADMUX,1
sbi     ADMUX,0

; set clock prescale 16
sbi 	ADCSRA,2
cbi	ADCSRA,1
cbi	ADCSRA,0

; enable ADC
sbi	ADCSRA,7

; end of configuration

sbi     ADCSRA,6	; start polling

loop:
	cbic 	ADCSRA,6
	rjmp	result			; AD conversion is ready jump to result
	rjmp 	loop			; AD conversion is still progress jump back to loop

result:
	; set led on arduono board pin 13 high to indicate result is ready
	rjmp	result; infinite loop	
