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
nextS     DB    " ",0

         .DATA
         .DATA?
inbuf     DB    100 DUP (?)
outbuf    DB    100 DUP (?)
allLength DD ?
ans       DD ? 

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
mov   ECX, allLength



; while 
m_while_st:
cmp   ECX, 0
jz m_while_end

  ; длинна текущего слова
  mov   AL, ' '
  repne scasb
  mov   EAX, allLength
  sub   EAX, ECX
  
  ; уменьшаем длинну всей строки
  sub   allLength, EAX
  
  push  ECX
  
  ; находим количество E в слове
  xor   EBX, EBX; количество
  sub   EDI, EAX; адрес
  mov   ECX, EAX; счетчик
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
  
  ; выводим количество искомых символов
  MOV     ans, EBX
  Invoke  dwtoa, ans, ADDR outbuf; число в строку
  Invoke  StdOut, ADDR outbuf    ; вывод
  Invoke  StdOut, ADDR nextS     ; вывод разделителя

  pop   ECX
  
jmp   m_while_st
m_while_end:






;    Add you statements
XOR    EAX, EAX
Invoke StdOut, ADDR MsgExit
Invoke StdIn, ADDR inbuf,LengthOf inbuf
	
Invoke ExitProcess, 0
End    Start

