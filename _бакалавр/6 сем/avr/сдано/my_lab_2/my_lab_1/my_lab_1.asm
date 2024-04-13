.include "m8515def.inc" ;���� ����������� ��� ATmega8515

.def temp = r16 ;��������� �������
.equ led = 0 ;0-� ��� ����� PB
.equ sw0 = 0 ;2-� ��� ����� PD
.equ sw1 = 1 ;3-� ��� ����� PD

.org $000
;***������� �������� ����������, ������� � ������ $000***
rjmp INIT ;��������� ������

.org $00D
rjmp int_decision ;�� ��������� ������� INT0
;***������������� SP, ������, �������� �����***


INIT:
		ldi temp,$5F ;���������
		out SPL,temp ; ��������� �����
		ldi temp,$02 ; �� ���������
		out SPH,temp ; ������ ���
		ser temp ;������������� �������
		out DDRB,temp ; ����� PB �� �����
		out PORTB,temp ;�������� ��
		clr temp ;�������������
		out DDRA,temp
		out DDRE,temp ; ����� PD �� ����
		ldi temp,0b00000011 ;��������� '�������������'
		out PORTA,temp ; ���������� ����� PD
		ldi temp,1
		out PORTE,temp
		ldi temp,(1<<INT2);���������� ����������
		out GICR,temp ; � 6,7 ����� �������� ����� GICR
		ldi temp,0 ;��������� ����������
		out MCUCR,temp ; �� ������� ������
		sei ;���������� ���������� ����������
loop:
		nop ;����� ��������
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

delay1: ;��� ������������ �������� 1 c
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


delay2: ;������������ �������� 2 c
		rcall delay1
		rcall delay1
		ret
