.include "m8515def.inc" ;файл определений для ATmega8515

.def temp = r16 ;временный регистр
.equ led = 0 ;0-о бит порта PB
.equ sw0 = 0 ;2-й бит порта PD
.equ sw1 = 1 ;3-й бит порта PD

.org $000
;***Таблица векторов прерываний, начиная с адреса $000***
rjmp INIT ;обработка сброса

.org $00D
rjmp int_decision ;на обработку запроса INT0
;***Инициализация SP, портов, регистра маски***


INIT:
		ldi temp,$5F ;установка
		out SPL,temp ; указателя стека
		ldi temp,$02 ; на последнюю
		out SPH,temp ; ячейку ОЗУ
		ser temp ;инициализация выводов
		out DDRB,temp ; порта PB на вывод
		out PORTB,temp ;погасить СД
		clr temp ;инициализация
		out DDRA,temp
		out DDRE,temp ; порта PD на ввод
		ldi temp,0b00000011 ;включение 'подтягивающих'
		out PORTA,temp ; резисторов порта PD
		ldi temp,1
		out PORTE,temp
		ldi temp,(1<<INT2);разрешение прерываний
		out GICR,temp ; в 6,7 битах регистра маски GICR
		ldi temp,0 ;обработка прерываний
		out MCUCR,temp ; по низкому уровню
		sei ;глобальное разрешение прерываний
loop:
		nop ;режим ожиданий
		rjmp loop
int_decision:
		sbis PINA,sw0
		rcall led_on1
		sbis PINA,sw1
		rcall led_on2
		reti


led_on1:
		cbi PORTB,led
		rcall delay1
		sbi PORTB,led
wait_0: sbis PINA,sw0
		rjmp wait_0
		ret


led_on2:
		cbi PORTB,led
		rcall delay2
		sbi PORTB,led
wait_1: sbis PINA,sw1
		rjmp wait_1
		ret

delay1: ;для подпрограммы задержки 1 c
		ldi r17,21
		d1:ldi r18,249
		d2:ldi r19,254
		d3:dec r19
		brne d3
		dec r18
		brne d2
		dec r17
		brne d1
		ret


delay2: ;подпрограмма задержки 2 c
		rcall delay1
		rcall delay1
		ret
