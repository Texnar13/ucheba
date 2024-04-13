
.include "m8515def.inc";���� ����������� ��� AT90S8515

.def temp = r16 ;��������� �������
.def reg_led = r20 ;������� ��������� �����������
.equ START = 0 ;0-�� ����� ����� 
.equ STOP = 1  ;1-�� ����� �����

.org $000

rjmp INIT


;***�������������***
INIT:   ldi reg_led, 0xFE ;����� reg_led.0 ��� ��������� LED0
		sec ;C=1
		set ;T=1 � ���� �����������
		ser temp ;������������� ������� (ser R1 - ������� � ������� ��������)
		out DDRB, temp ; ���� B ���� �� �����
		out PORTB, temp ; ������� ������� � ����� B, ��� ������� ����������

		clr temp ; ����� ����� � �������
		out DDRD,temp ; ����� PD �� ����
		ldi temp,0x03 ;��������� ��������������� 
		out PORTD,temp ; ���������� ����� PD (0-�, 1-� �������)
		rjmp WAITSTART


WAITSTART: ;��������
		sbic PIND, START; ������� (sbic - ������� ��� ����� START � ����� PIND, ���� 0, ����������)
		rjmp WAITSTART ; ������ START
		rjmp LOOP

LOOP:   
		brts NOINV; �������, ���� ���� T ����������
		mov r21, reg_led
		com r21 ; ��������
		out PORTB, r21 ;����� �� ����������
		rjmp LOOP_DELAY
NOINV:	out PORTB, reg_led;����� �� ����������


LOOP_DELAY:;***�������� (��� ��������� �����)***
        ldi r17, 215 ;(LDI Rd, K �������� ��������� � ������)
	d0:	ldi r18, 144
		d1: ldi r19, 10
			d2: dec r19
				brne d2
			dec r18
			brne d1
		dec r17 ; (��������� �������� ; ��������: Z,N,V)
		brne d0 ; (�������, ���� �� �����)


		sbic PIND, STOP ;���� ������ ������ STOP, (sbic - ������� ��� ����� STOP � ����� PIND, ���� 0, ����������)
		rjmp CONTINUE ; ���� �� ������ ���� ������ �� �����
		rjmp WAITSTART ; ���� ������, ���� � �������� ������ START
CONTINUE: 	

    	SBRC reg_led, 7 ; ������� ��������� �������, ���� 7-� ������ � reg_led = 0
		rjmp SHIFT ; ������� �������� ����� � ������� ��������
		

		; �������� ����� T
		brts INV_1 ; �������, ���� ���� T ����������
		set ;T=1 
		rjmp INV_END
INV_1:	clt ; T=0 
INV_END:
		
		;����� reg_led.0 ��� ��������� LED0
		ldi reg_led, 0xFE 
		rjmp LOOP


SHIFT:	rol reg_led ;����� reg_led ����� �� 1 ������
		rjmp LOOP
