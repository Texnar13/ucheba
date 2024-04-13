;_________________________________________________________________________
;
; ������ ����
; ������ ��6-62�
; ��1
; ������� 2
;_________________________________________________________________________
;
; �������:
;
;
;_________________________________________________________________________

.include "m8515def.inc";���� ����������� ��� AT90S8515

.def temp = r16 ;��������� �������
.def reg_led = r20 ;������� ��������� �����������
.def DELAY_REG0 = r18;
.def DELAY_REG1 = r21;

.def abc = r17
.def DELAY_REG2 = r19;

;.equ START = 0 ;0-�� ����� ����� 




.org $000
	rjmp init


;***�������������***
init:
	ldi temp, low(RAMEND)    ; ���������
	out SPL, temp            ; ��������� �����
	ldi temp, high(RAMEND)   ; �� ���������
	out SPH, temp            ; ������ ���

	SER temp                 
	out DDRA, temp           ; ������������� ����� PA �� �����
	CLR temp                 ; � temp ��� ����
	out PORTA, temp          ; ��� ���������� ����� PA, �� ���� � 0


UPINIT:                   ; ��������� ��������� ��� ����� � 31 �� 0
    CLR abc            
UPSTEP:
    OUT PORTA, abc           ; ����� �� PA ��������� ����������
	RCALL DELAYL             ; ����� ������������ ��������
	INC abc                  ; abc = abc + 1
	CPI abc, 0x1F            ; ��������� 
	BREQ DOWNINIT            ; ������� ���� �����
	RJMP UPSTEP

DOWNINIT:
	LDI abc, 0x1F            ; ��������� ��������� ��� ����� � 0 �� 31
DOWNSTEP:
	OUT PORTA, abc           ; ����� �� PA ��������� ����������
	RCALL DELAYL             ; ����� ������������ ��������
	DEC abc                  ; abc = abc - 1
	CPI abc, 0x00            ; ��������� �
	BREQ UPINIT              ; ������� ���� �����
	RJMP DOWNSTEP


; ��������
DELAYL: ; ����� ������ 0.75us
		; �������� ���������

		LDI DELAY_REG0, 0x05; 0.25us
	d0: 

		LDI DELAY_REG1, 0x6E; 0.25us
	d1: 

		LDI DELAY_REG2, 0xF0; 0.25us
	d2: DEC DELAY_REG2 ; 0.25us        = 180,25
		BRNE d2        ; 0.50us

		DEC DELAY_REG1 ; 0.25us            = 19910,25us
		BRNE d1        ; 0.50us


		DEC DELAY_REG0 ; 0.25us
		BRNE d0        ; 0.50us


		
		RET; ������� �� ������ 1.00us


; 1000 = 1 + 0.75 + 0.25 + 998 = 2 + 998 

; 998 = (0.25+0.25+0.5)  * 200 + 3,99 * 200)   998 

;998 =+- 999 = 3*111






;
;
;
;
;; ��������
; ����� ������ 0.75us
;		; �������� ��������� 0.25us
;		LDI DELAY_REG1, 0xC6
;
;	d2: DEC DELAY_REG1 ; 0.25us
;		NOP            ; 0.25us  + = 1us
;		BRNE d2        ; 0.50us
;
;		; ������� �� ������ 1.00us
;		RET
;
;
; 200 = 1+ 0.75+0.25 + 198 = 2 + 198 = 2 + 0xC6
;
;
;(��� ������� 4 ���)
;
;
;
;
;






;		   ldi r17, 215 ;(LDI Rd, K �������� ��������� � ������)
;	d0:	ldi r18, 144
;		d1: ldi r19, 10
;			d2: dec r19
;				brne d2
;			dec r18
;			brne d1
;		dec r17 ; (��������� �������� ; ��������: Z,N,V)
;		brne d0 ; (�������, ���� �� �����)

		

