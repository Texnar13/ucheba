;_________________________________________________________________________
;
; МАРЧУК ИВАН
; ГРУППА ИУ6-62Б
; РК1
; ВАРИАНТ 2
;_________________________________________________________________________
;
; ЗАДАНИЕ:
;
;
;_________________________________________________________________________

.include "m8515def.inc";файл определений для AT90S8515

.def temp = r16 ;временный регистр
.def reg_led = r20 ;регистр состояния светодиодов
.def DELAY_REG0 = r18;
.def DELAY_REG1 = r21;

.def abc = r17
.def DELAY_REG2 = r19;

;.equ START = 0 ;0-ой вывод порта 




.org $000
	rjmp init


;***Инициализация***
init:
	ldi temp, low(RAMEND)    ; установка
	out SPL, temp            ; указателя стека
	ldi temp, high(RAMEND)   ; на последнюю
	out SPH, temp            ; ячейку ОЗУ

	SER temp                 
	out DDRA, temp           ; инициализация порта PA на вывод
	CLR temp                 ; в temp все нулю
	out PORTA, temp          ; все светодиоды горят PA, тк счет с 0


UPINIT:                   ; начальное состояние при счете с 31 до 0
    CLR abc            
UPSTEP:
    OUT PORTA, abc           ; вывод на PA временной переменной
	RCALL DELAYL             ; вызов подпрограммы задержки
	INC abc                  ; abc = abc + 1
	CPI abc, 0x1F            ; сравнение 
	BREQ DOWNINIT            ; переход если равно
	RJMP UPSTEP

DOWNINIT:
	LDI abc, 0x1F            ; начальное состояние при счете с 0 до 31
DOWNSTEP:
	OUT PORTA, abc           ; вывод на PA временной переменной
	RCALL DELAYL             ; вызов подпрограммы задержки
	DEC abc                  ; abc = abc - 1
	CPI abc, 0x00            ; сравнение и
	BREQ UPINIT              ; переход если равно
	RJMP DOWNSTEP


; задержка
DELAYL: ; вызов метода 0.75us
		; загрузка константы

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


		
		RET; возврат из метода 1.00us


; 1000 = 1 + 0.75 + 0.25 + 998 = 2 + 998 

; 998 = (0.25+0.25+0.5)  * 200 + 3,99 * 200)   998 

;998 =+- 999 = 3*111






;
;
;
;
;; задержка
; вызов метода 0.75us
;		; загрузка константы 0.25us
;		LDI DELAY_REG1, 0xC6
;
;	d2: DEC DELAY_REG1 ; 0.25us
;		NOP            ; 0.25us  + = 1us
;		BRNE d2        ; 0.50us
;
;		; возврат из метода 1.00us
;		RET
;
;
; 200 = 1+ 0.75+0.25 + 198 = 2 + 198 = 2 + 0xC6
;
;
;(для частоты 4 Мгц)
;
;
;
;
;






;		   ldi r17, 215 ;(LDI Rd, K Загрузка константы в ргистр)
;	d0:	ldi r18, 144
;		d1: ldi r19, 10
;			d2: dec r19
;				brne d2
;			dec r18
;			brne d1
;		dec r17 ; (Декремент регистра ; Признаки: Z,N,V)
;		brne d0 ; (Перейти, если не равно)

		

