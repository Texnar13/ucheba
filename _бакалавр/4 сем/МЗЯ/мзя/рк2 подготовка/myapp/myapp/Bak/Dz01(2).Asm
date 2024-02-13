; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
msgEnter DB "Enter eight words separated by spaces and no more than 50 characters:",0AH,0DH,0
MsgExit  DB    0AH,0DH,"Press Enter to Exit",0AH,0DH,0
nextS    DB    " ",0

         .DATA
separate DB ' '; разделитель слов
symbol   DB 'E'; искомый символ

         .DATA?
inbuf    DB    100 DUP (?)
ans      DWORD ? 

         .CODE
Start:
;
;  Вариант 16. 
;  Дан текст 8 слов, разделенных пробелом. 
;  Определить количество повторений буквы Е в каждом слове.
;  EEEE EEE testEr CHETSRE PYAT Shest SEm VOSeM




         Invoke StdOut, ADDR msgEnter          ; Приглашение

         Invoke StdIn,ADDR inbuf,LengthOf inbuf; вводим строку
         LEA    EDI, inbuf   ; получаем адрес начала строки
         
         MOV    ECX, 8
eight_cycle:          ; цикл из восьми слов
         PUSH   ECX
         
         
         PUSH   EDI          ; запоминаем адрес начала слова
         MOV    ECX, 50      ; слово не может быть больше 50, но к сожалению заранее длинну слова не выяснить
         MOV    AL,  separate; записываем ссылку на разделитель в элемент al
         CLD                 ; обработака от начала к концу
   REPNE SCASB               ; ищем разделитель(конец строки) попутно увеличивая счетчик EDI в итоге получая длинну слова
         MOV    EBX, EDI     ; запоминаем адрес конца слова
         POP    EDI          ; возвращаем обратно адрес начала слова
         
         
         MOV    EAX, 0; Инициализируем количество E в слове
         
         
         
         
         
         
word_cycle: ; цикл while(поисковый) по длинне слова         
         CMP    EDI, EBX; пока EDI <> EBX
         JE    word_cycle_end
         
         
         MOV    CL, symbol        ; сравниваем текущий символ с искомым, и если находим 
         CMP    CL, DS:[EDI] 
         JNE    symbol_if_end
         INC    EAX               ; увеличиваем количество E на 1
symbol_if_end:                    ; если не находим, то ничего не делаем
         
         
         INC    EDI; переходим к следующему элементу
         
         
         JMP word_cycle
word_cycle_end:
         
         
         ; выводим количество искомых символов
         MOV    ans, EAX
         Invoke dwtoa, ans, ADDR inbuf   ; прреодразование ответа-числа в строку
         Invoke StdOut, ADDR inbuf       ; вывод
         Invoke StdOut, ADDR nextS       ; вывод разделителя
         
         
         POP    ECX
         LOOP   eight_cycle; переход к следующему слову
         
         
         
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         
End    Start

