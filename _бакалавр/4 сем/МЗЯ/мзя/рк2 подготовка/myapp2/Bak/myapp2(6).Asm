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
allLength DD ?
ans       DD ? 

         .CODE
Start:
; ��� ����� 8 ���� ����������� ��������
; ���������� ���������� ���������� ����� E ������ �����


; ������ ������
Invoke StdOut, ADDR msgEnter          
Invoke StdIn, ADDR inbuf, LengthOf inbuf

; ������ ���� ������
lea   EDI, inbuf
mov   ECX, 100
mov   AL, 0
repne scasb
mov   allLength, 100
sub   allLength, ECX
dec   allLength

; ���������� �� ������
lea   EDI, inbuf
mov   ECX, allLength



; while 
m_while_st:
cmp   ECX, 0
jz m_while_end

  ; ������ �������� �����
  mov   AL, ' '
  repne scasb
  mov   EAX, 100
  sub   EAX, ECX
  dec   EAX
  
  push  ECX
  
  ; ������� ���������� E � �����
  xor   EBX, EBX; �������
  sub   EDI, EAX; �����
  mov   ECX, EAX
  mov   AL, 'E'
  m_do_while:; do 
  
    repne scasb
    ; ����� �� ����� �����?
    cmp   ECX, 0 
    JZ    m_end
      inc EBX ; ���� �� ����� 
    m_end:
  ; while
  JNZ     m_do_while
  
  ; ������� ���������� ������� ��������
  MOV     ans, EBX
  Invoke  dwtoa, ans, ADDR inbuf ; ����� � ������
  Invoke  StdOut, ADDR inbuf     ; �����
  Invoke  StdOut, ADDR nextS     ; ����� �����������

  pop   ECX
  
jmp   m_while_st
m_while_end:






;    Add you statements
XOR    EAX, EAX
Invoke StdOut, ADDR MsgExit
Invoke StdIn, ADDR inbuf,LengthOf inbuf
	
Invoke ExitProcess, 0
End    Start

