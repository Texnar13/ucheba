; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
msgEnterQ  DB    "Please enter q:",0
msgEnterA  DB    "Please enter a:",0
msgEnterD  DB    "Please enter d:",0
msgAnswer  DB    "n= ",0
msgExit    DB    0AH,0DH,"Press Enter to Exit",0AH,0DH,0

         .DATA



         .DATA?
inbuf    DB    100 DUP (?)
myInBuffer DB 10 DUP (?) 

vQ       DWORD ? 
vA       DWORD ? 
vD       DWORD ? 
ans      DWORD ? 

         .CODE
Start:
; 
;    Add you statements
;

  ; ввод q  
  Invoke StdOut,  ADDR msgEnterQ
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer      ; ѕреобразование в SDWORD c нулем на конце
  Invoke atol,    ADDR myInBuffer      ; преобразовываем строку с нулем в число, а результат в EAX
  MOV    vQ, EAX    
  
  ; ввод A
  Invoke StdOut,  ADDR msgEnterA
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer
  Invoke atol,    ADDR myInBuffer
  MOV    vA, EAX  
  
  
  CMP vQ, 5          ; —равниваем q с 5
  JNG max_else       ; если q меньше или равно 5 переходим к метке max_else
  
  
  ; ввод D
  Invoke StdOut,  ADDR msgEnterD
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer
  Invoke atol,    ADDR myInBuffer
  MOV    vD, EAX   
  
  MOV EAX, vQ        ; считаем от вет дл€ q > 5 (Q^2/3 - a*d)
  MUL EAX
  CDQ                ; двойное слово в учетверенное EAX -> EDX:EAX
  MOV CX, 3
  DIV CX
  MOV ans, EAX
  MOV EAX, vA
  MUL vD
  SUB ans, EAX
  JMP middle_max_end ; отправл€емс€ в конец услови€ middle_max_end
  
  
max_else:

  CMP vQ, -5         ; —равниваем q с -5
  JL middle_else     ; ≈сли q строго меньше -5 переходим к метке middle_else   
  
  MOV EAX, vA        ; считаем ответ дл€ -5 >= q >= 5 (a+q)
  ADD EAX, vQ
  MOV ans, EAX
  JMP middle_max_end ; переходим к концу слови€ middle_max_end  
  
middle_else:  
  
  MOV EAX, vA        ; считаем от вет дл€ q < -5 (a)
  MOV ans, EAX
  
middle_max_end:     
  
  
  ; выводим ответ
  Invoke StdOut, ADDR msgAnswer       ; вывод описани€ ответа
  Invoke dwtoa,  ans, ADDR myInBuffer ; прреодразование ответа-числа в строку
  Invoke StdOut, ADDR myInBuffer      ; вывод


  XOR    EAX,EAX
  Invoke StdOut,ADDR msgExit
  Invoke StdIn,ADDR inbuf,LengthOf inbuf		
  
  Invoke ExitProcess,0

End Start

