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
separate DB ' '; ����������� ����
symbol   DB 'E'; ������� ������

         .DATA?
inbuf    DB    100 DUP (?)
ans      DWORD ? 

         .CODE
Start:
;
;  ������� 16. 
;  ��� ����� 8 ����, ����������� ��������. 
;  ���������� ���������� ���������� ����� � � ������ �����.
;  EEEE EEE testEr CHETSRE PYAT Shest SEm VOSeM





         Invoke StdIn,ADDR inbuf,LengthOf inbuf; ������ ������
         LEA    EDI, inbuf   ; �������� ����� ������ ������
         
         MOV    ECX, 8
eight_cycle:          ; ���� �� ������ ����
         PUSH   ECX
         
         
         PUSH   EDI          ; ���������� ����� ������ �����
         MOV    AL,  separate; ���������� ������ �� ����������� � ������� al
         CLD                 ; ���������� �� ������ � �����
   REPNE SCASB               ; ���� �����������(����� ������) ������� ���������� ������� EDI � ����� ������� ������ �����
         MOV    EBX, EDI     ; ���������� ����� ����� �����
         POP    EDI          ; ���������� ������� ����� ������ �����
         
         
         MOV    EAX, 0; �������������� ���������� E � �����
         
         
         
         
         
         
word_cycle: ; ���� while(���������) �� ������ �����         
         CMP    EDI, EBX; ���� EDI <> EBX
         JE    word_cycle_end
         
         
         MOV    CL, symbol        ; ���������� ������� ������ � �������, � ���� ������� 
         CMP    CL, DS:[EDI] 
         JNE    symbol_if_end
         INC    EAX               ; ����������� ���������� E �� 1
symbol_if_end:                    ; ���� �� �������, �� ������ �� ������
         
         
         INC    EDI; ��������� � ���������� ��������
         
         
         JMP word_cycle
word_cycle_end:
         
         
         ; ������� ���������� ������� ��������
         MOV    ans, EAX
         Invoke dwtoa, ans, ADDR inbuf   ; ��������������� ������-����� � ������
         Invoke StdOut, ADDR inbuf       ; �����
         Invoke StdOut, ADDR separate    ; ����� �����������
         
         
         POP    ECX
         LOOP   eight_cycle; ������� � ���������� �����
         
         
         
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         
End    Start

