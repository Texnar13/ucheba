; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    "Press Enter to Exit",0AH,0DH,0

         .DATA
A     DWORD -30
B     DWORD 21
val1  BYTE     255 ; DS:[403008]
chart WORD     256 ; DS:[403009]
lue3  SWORD    -128
v5    BYTE     10h
      BYTE     100101B
beta  BYTE     23,23h,0ch
sdk   BYTE     "Hello",0
min   SWORD    -32767
ar    DWORD    12345678h
valar BYTE     5 DUP (1, 2, 8)
my_first WORD 37
my_second WORD 9472

         .DATA?
X     DWORD ?
alu   BYTE     ?
         
inbuf    DB    100 DUP (?)

         .CODE
Start:
; 
;    Add you statements
;

  mov EAX,A  
  add EAX,5 
  sub EAX,B 
  mov X,EAX 


         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
End Start

