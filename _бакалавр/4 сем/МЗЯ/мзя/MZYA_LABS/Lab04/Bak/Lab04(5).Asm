; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
msgEnterLine  DB    "Enter 5 values - line ",0
msgCalculate  DB    "Calculate",0AH,0DH,0
msgExit       DB    "Press Enter to Exit",0AH,0DH,0
nextLine      DB    0AH,0DH,0
space         DB    " ",0
matr          DWORD 1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,20,1,2,3,4,5

         .DATA 

         .DATA?
;matr          DWORD 25  DUP (?) 
myInOutBuffer DB    10  DUP (?) 
regOutBuf     DWORD ?

         .CODE
Start:


; 
;    Add you statements
; 
;
; ���� ������� 5�5. ���������� �� ������ ������ ������������ �������, ������� 4, 
; � ��������� ��� �� ����� ��������� �������� ���������. 
; ������������ ���� ������� � ����� �����������. 
        
        
        
        
      


; �������

        Invoke StdOut, ADDR msgCalculate
        
        
        
        
        mov    ECX, 5 ; ���������� ���������� �����
        mov    EDI, 0 ; ������ ��������
cycle_str_calc:       ; ���� �� �������
        push   ECX 
        
        mov    EAX, 1; ����������� ������������ ���� ��������� � ������ 
        
        mov    ECX, 5 ; ���������� ���������� �����
cycle_col_calc:       ; ���� �� ��������
        push   ECX    ; �������� �������� ECX � ����		
        push   EAX
        
        
        mov    EAX, matr[EDI*4]; �������� ��������� 4 todo DX:AX-------------------------------------------------
        mov    EDX, 0
        mov    EBX, 4
        div    BX
        
        
        cmp    DX, 0
        JNE    calc_else       ; ���� �� ������, ���������� ��������� ���
        mul    matr[EDI*4]     ; ���� ������, �������� ����� ������������
calc_else: 
            
        inc    EDI            ; ����������� ������ �������� �� 1
        pop    EAX
        pop    ECX            ; ����� �������� ECX �� �����
        loop   cycle_col_calc
        
        
        Invoke StdOut, ADDR nextLine                  ; ������ ������ ����� ������
        
        pop    ECX 
        loop   cycle_str_calc
                 
        
        
        
        












; �����
     
        mov    ECX, 5 ; ���������� ���������� �����
        mov    EDI, 0 ; ������ ��������       
cycle_str_output:     ; ���� �� �������
        push   ECX 
        
        
        mov    ECX, 5 ; ���������� ���������� �����
cycle_col_output:     ; ���� �� ��������
        push   ECX    ; �������� �������� ECX � ����		
            
        Invoke dwtoa, matr[EDI*4], ADDR myInOutBuffer ; ��������� ������� � ������
        Invoke StdOut, ADDR myInOutBuffer             ; ������� �������
        Invoke StdOut, ADDR space                     ; ������ ������ ����������
            
        inc    EDI    ; ����������� ������ �������� �� 1
        pop    ECX    ; ����� �������� ECX �� �����
        loop   cycle_col_output
        
        
        Invoke StdOut, ADDR nextLine                  ; ������ ������ ����� ������
        
        pop    ECX 
        loop   cycle_str_output
                 











         XOR    EAX,EAX
         Invoke StdOut,ADDR msgExit
         Invoke StdIn,ADDR myInOutBuffer,LengthOf myInOutBuffer	
	
         Invoke ExitProcess,0
         
End    Start

