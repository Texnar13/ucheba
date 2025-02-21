; Lab 02 Marchuk
  .586
  .MODEL  flat, stdcall
  OPTION  CASEMAP:NONE

Include    kernel32.inc
Include    masm32.inc
IncludeLib kernel32.lib
IncludeLib masm32.lib

.CONST
  MsgExit   DB 0AH, 0DH, 0AH, 0DH,"Press Enter to Exit", 0AH, 0DH, 0
  helloText DB "Please, enter a, d, q",0AH, 0DH, 0
  endText   DB "(q^2)/3 - a*d + 5 = ",  0
  strEnd    DB 0AH, 0DH, 0

.DATA
  A Word 5, -5
  
.DATA?
  myInBuffer DB 10 DUP (?) 
  vA         DWORD ?
  vD         DWORD ?
  vQ         DWORD ?
  ans        DWORD ?
  
.CODE
Start:
  ; 
  ; n = (q^2)/3 - a*d + 5
  ;    
  
  XOR    EAX, EAX
  
  mov AX, ptr DS:[00403005]



  Invoke StdOut, ADDR helloText
  
  ; ���� ����� A
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer      ; �������������� � SDWORD
  Invoke atol,    ADDR myInBuffer      ; ��������� � EAX
  mov    vA, EAX  
  
  ; ���� ����� D
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer      ; �������������� � SDWORD
  Invoke atol,    ADDR myInBuffer      ; ��������� � EAX
  mov    vD, EAX 
  
  ; ���� ����� Q
  Invoke StdIn,   ADDR myInBuffer, LengthOf myInBuffer
  Invoke StripLF, ADDR myInBuffer      ; �������������� � SDWORD
  Invoke atol,    ADDR myInBuffer      ; ��������� � EAX
  mov    vQ, EAX
  
  ; �������
  
  mul EAX      ;(q^2) EDX:EAX = EAX*EAX
  
  mov ECX, 3
  div ECX      ;EAX = (EDX:EAX)/ECX
  mov ECX, EAX ; ��������� ���������
  
  mov EAX, vA
  mul vD       ; EDX:EAX = EAX*vD 
  
  sub ECX, EAX ; ECX = ECX - EAX
  add ECX, 5   ; ECX = ECX + 5
  
  mov ans, ECX
  
  ; ����� ������
  Invoke StdOut, ADDR endText         ; ����� �������� ������
  Invoke dwtoa,  ans, ADDR myInBuffer ; �������������� ������-����� � ������
  Invoke StdOut, ADDR myInBuffer      ; �����
  Invoke StdOut, ADDR strEnd
  
  
  XOR    EAX, EAX
  Invoke StdOut, ADDR MsgExit
  Invoke StdIn, ADDR myInBuffer, LengthOf myInBuffer
  
  Invoke ExitProcess, 0
         
End Start




