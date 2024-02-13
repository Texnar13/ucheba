; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit   DB    "Press Enter To Exit",0AH,0DH,0
msgEnter  DB "Enter eight words separated by spaces and no more than 50 characters:",0AH,0DH,0
         .DATA

         .DATA?
inbuf     DB    100 DUP (?)
allLength DD ?

         .CODE
Start:
; Дан текст 8 слов разделенных пробелом
; Определить количество повторений буквы E каждом слове


; вводим строку
Invoke StdOut, ADDR msgEnter          
Invoke StdIn, ADDR inbuf, LengthOf inbuf

; длинна всей строки
lea   EDI, inbuf
mov   ECX, 100
mov   AL, 0
repne scasb
mov   allLength, 100
sub   allLength, ECX
dec   allLength

; проходимся по словам
lea   EDI, inbuf

; длинна текущего слова
mov   ECX, allLength
mov   AL, ' '
repne scasb
mov   EAX, 100
sub   EAX, ECX
dec   EAX

; находим количество E в слове
xor   EBX, EBX; счетчик
sub   EDI, EAX; адрес
mov   ECX, EAX
mov   AL, 'E'
m_do_while:; do 

  repne scasb
  ; дошли до конца слова?
  cmp   ECX, 0 
  JZ    m_end
    inc EBX ; если не дошли 
  m_end:
; while
JNZ     m_do_while








;    Add you statements
XOR    EAX, EAX
Invoke StdOut, ADDR MsgExit
Invoke StdIn, ADDR inbuf,LengthOf inbuf
	
Invoke ExitProcess, 0
End    Start

