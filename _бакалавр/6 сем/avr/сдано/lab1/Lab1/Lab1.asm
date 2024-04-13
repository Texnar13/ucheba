
.include "m8515def.inc";файл определений для AT90S8515

.def temp = r16 ;временный регистр
.def reg_led = r20 ;регистр состояния светодиодов
.equ START = 0 ;0-ой вывод порта 
.equ STOP = 1  ;1-ый вывод порта

.org $000

rjmp INIT


;***Инициализация***
INIT:   ldi reg_led, 0xFE ;сброс reg_led.0 для включения LED0
		sec ;C=1
		set ;T=1 – флаг направления
		ser temp ;инициализация выводов (ser R1 - единицы в разряды регистра)
		out DDRB, temp ; порт B весь на вывод
		out PORTB, temp ; вывести единицы с порта B, что погасит светодиоды

		clr temp ; вывод нулей в регистр
		out DDRD,temp ; порта PD на ввод
		ldi temp,0x03 ;включение ‘подтягивающих’ 
		out PORTD,temp ; резисторов порта PD (0-й, 1-й разряды)
		rjmp WAITSTART


WAITSTART: ;ожидание
		sbic PIND, START; нажатия (sbic - смотрим бит номер START в порту PIND, если 0, пропускаем)
		rjmp WAITSTART ; кнопки START
		rjmp LOOP

LOOP:   
		brts NOINV; перейти, если флаг T установлен
		mov r21, reg_led
		com r21 ; инверсия
		out PORTB, r21 ;вывод на индикаторы
		rjmp LOOP_DELAY
NOINV:	out PORTB, reg_led;вывод на индикаторы


LOOP_DELAY:;***Задержка (три вложенных цикла)***
        ldi r17, 215 ;(LDI Rd, K Загрузка константы в ргистр)
	d0:	ldi r18, 144
		d1: ldi r19, 10
			d2: dec r19
				brne d2
			dec r18
			brne d1
		dec r17 ; (Декремент регистра ; Признаки: Z,N,V)
		brne d0 ; (Перейти, если не равно)


		sbic PIND, STOP ;если нажата кнопка STOP, (sbic - смотрим бит номер STOP в порту PIND, если 0, пропускаем)
		rjmp CONTINUE ; если не нажата идем дальше по циклу
		rjmp WAITSTART ; если нажата, идем к проверке кнопки START
CONTINUE: 	

    	SBRC reg_led, 7 ; пропуск следующей команды, если 7-й разряд в reg_led = 0
		rjmp SHIFT ; пропуск инверсии флага и очистки регистра
		

		; инверсия флага T
		brts INV_1 ; переход, если флаг T установлен
		set ;T=1 
		rjmp INV_END
INV_1:	clt ; T=0 
INV_END:
		
		;сброс reg_led.0 для включения LED0
		ldi reg_led, 0xFE 
		rjmp LOOP


SHIFT:	rol reg_led ;сдвиг reg_led влево на 1 разряд
		rjmp LOOP
