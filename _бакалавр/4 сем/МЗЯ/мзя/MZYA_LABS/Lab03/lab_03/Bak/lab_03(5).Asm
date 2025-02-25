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

  ; ���� q  
  Invoke StdOut,  ADDR msgEnterQ
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer      ; �������������� � SDWORD c ����� �� �����
  Invoke atol,    ADDR myInBuffer      ; ��������������� ������ � ����� � �����, � ��������� � EAX
  MOV    vQ, EAX    
  
  ; ���� A
  Invoke StdOut,  ADDR msgEnterA
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer
  Invoke atol,    ADDR myInBuffer
  MOV    vA, EAX  
  
  
  CMP vQ, 5          ; ���������� q � 5
  JNG max_else       ; ���� q ������ ��� ����� 5 ��������� � ����� max_else
  
  
  ; ���� D
  Invoke StdOut,  ADDR msgEnterD
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer
  Invoke atol,    ADDR myInBuffer
  MOV    vD, EAX   
  
  MOV EAX, vQ        ; ������� �� ��� ��� q > 5 (Q^2/3 - a*d)
  MUL EAX
  CDQ                ; ������� ����� � ������������ EAX -> EDX:EAX
  MOV ECX, 3
  DIV ECX
  MOV ans, EAX
  MOV EAX, vA
  MUL vD
  SUB ans, EAX
  JMP middle_max_end ; ������������ � ����� ������� middle_max_end
  
  
max_else:

  CMP vQ, -5         ; ���������� q � -5
  JL middle_else     ; ���� q ������ ������ -5 ��������� � ����� middle_else   
  
  MOV EAX, vA        ; ������� ����� ��� -5 >= q >= 5 (a+q)
  ADD EAX, vQ
  MOV ans, EAX
  JMP middle_max_end ; ��������� � ����� ������ middle_max_end  
  
middle_else:  
  
  MOV EAX, vA        ; ������� �� ��� ��� q < -5 (a)
  MOV ans, EAX
  
middle_max_end:     
  
  
  ; ������� �����
  Invoke StdOut, ADDR msgAnswer       ; ����� �������� ������
  Invoke dwtoa,  ans, ADDR myInBuffer ; ��������������� ������-����� � ������
  Invoke StdOut, ADDR myInBuffer      ; �����


  XOR    EAX,EAX
  Invoke StdOut,ADDR msgExit
  Invoke StdIn,ADDR inbuf,LengthOf inbuf		
  
  Invoke ExitProcess,0

End Start

